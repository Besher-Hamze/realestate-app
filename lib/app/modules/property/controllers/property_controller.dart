import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/app/data/models/property_model.dart';
import 'package:real_estate_app/app/data/repositories/favorite_repository.dart';
import 'package:real_estate_app/app/data/repositories/property_repository.dart';
import 'package:real_estate_app/app/utils/constants.dart';
import 'package:real_estate_app/app/utils/helpers.dart';

class PropertyController extends GetxController {
  final PropertyRepository _propertyRepository = Get.find<PropertyRepository>();
  final FavoriteRepository _favoriteRepository = Get.find<FavoriteRepository>();

  // Properties list
  final properties = <PropertyModel>[].obs;
  final filteredProperties = <PropertyModel>[].obs;
  final selectedProperty = Rxn<PropertyModel>();

  // Pagination
  final totalPages = 0.obs;
  final currentPage = 1.obs;
  final totalCount = 0.obs;
  final pageSize = 10.obs;

  // Loading states
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isFavoriteLoading = false.obs;

  // Filtering
  final propertyFilter = PropertyFilter().obs;
  final searchQuery = ''.obs;

  // Filter UI controls
  final selectedPropertyType = Rxn<String>();
  final selectedBedrooms = Rxn<int>();
  final selectedLocation = Rxn<String>();
  final selectedPriceRange = Rxn<Map<String, dynamic>>();
  final selectedSortOption = Rxn<String>();

  // Search controller
  final searchController = TextEditingController();

  // Favorite status
  final isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default sorting
    propertyFilter.value.sortBy = 'date';
    propertyFilter.value.sortDirection = 'desc';
    selectedSortOption.value = 'date_desc';

    // Set default page size
    propertyFilter.value.pageSize = 10;

    // Load properties
    getAllProperties();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Get all properties with current filter
  Future<void> getAllProperties({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        propertyFilter.value.page = 1;
      }

      isLoading.value = true;

      final response = await _propertyRepository.getAllProperties(propertyFilter.value);

      if (refresh || currentPage.value == 1) {
        properties.clear();
      }

      properties.addAll(response.properties);
      filteredProperties.value = properties;

      totalPages.value = response.totalPages;
      totalCount.value = response.totalCount;
      currentPage.value = response.currentPage;
      pageSize.value = response.pageSize;
    } catch (e) {
      Helpers.showErrorSnackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Load more properties (pagination)
  Future<void> loadMoreProperties() async {
    if (currentPage.value < totalPages.value && !isLoadingMore.value) {
      try {
        isLoadingMore.value = true;

        propertyFilter.value.page = currentPage.value + 1;

        final response = await _propertyRepository.getAllProperties(propertyFilter.value);

        properties.addAll(response.properties);
        filteredProperties.value = properties;

        totalPages.value = response.totalPages;
        totalCount.value = response.totalCount;
        currentPage.value = response.currentPage;
      } catch (e) {
        Helpers.showErrorSnackbar('خطأ', e.toString());
      } finally {
        isLoadingMore.value = false;
      }
    }
  }

  // Search properties
  Future<void> searchProperties(String query) async {
    if (query.isEmpty) {
      searchQuery.value = '';
      filteredProperties.value = properties;
      return;
    }

    try {
      isLoading.value = true;
      searchQuery.value = query;

      final response = await _propertyRepository.searchProperties(query);

      filteredProperties.value = response.properties;

      totalPages.value = response.totalPages;
      totalCount.value = response.totalCount;
      currentPage.value = response.currentPage;
    } catch (e) {
      Helpers.showErrorSnackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Get property details
  Future<void> getPropertyDetails(String id) async {
    try {
      isLoading.value = true;

      final property = await _propertyRepository.getPropertyDetails(id);
      selectedProperty.value = property;

      // Check if property is in favorites
      await checkFavoriteStatus(id);
    } catch (e) {
      print(e);
      Helpers.showErrorSnackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Check if property is in favorites
  Future<void> checkFavoriteStatus(String propertyId) async {
    try {
      isFavoriteLoading.value = true;
      isFavorite.value = await _favoriteRepository.isFavorite(propertyId);
    } catch (e) {
      print('Error checking favorite status: $e');
      isFavorite.value = false;
    } finally {
      isFavoriteLoading.value = false;
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String propertyId) async {
    try {
      isFavoriteLoading.value = true;

      if (isFavorite.value) {
        await _favoriteRepository.removeFromFavorites(propertyId);
        isFavorite.value = false;
        Helpers.showSuccessSnackbar('تمت العملية', 'تمت إزالة العقار من المفضلة');
      } else {
        await _favoriteRepository.addToFavorites(propertyId);
        isFavorite.value = true;
        Helpers.showSuccessSnackbar('تمت العملية', 'تمت إضافة العقار إلى المفضلة');
      }
    } catch (e) {
      Helpers.showErrorSnackbar('خطأ', e.toString());
    } finally {
      isFavoriteLoading.value = false;
    }
  }

  // Apply filters
  void applyFilters() {
    propertyFilter.value = propertyFilter.value.copyWith(
      propertyType: selectedPropertyType.value,
      bedrooms: selectedBedrooms.value,
      location: selectedLocation.value,
      minPrice: selectedPriceRange.value?['min'],
      maxPrice: selectedPriceRange.value?['max'] == -1 ? null : selectedPriceRange.value?['max'],
    );

    // Parse sort option
    if (selectedSortOption.value != null) {
      final sortParts = selectedSortOption.value!.split('_');
      if (sortParts.length == 2) {
        propertyFilter.value = propertyFilter.value.copyWith(
          sortBy: sortParts[0],
          sortDirection: sortParts[1],
        );
      }
    }

    getAllProperties(refresh: true);
  }

  // Reset filters
  void resetFilters() {
    selectedPropertyType.value = null;
    selectedBedrooms.value = null;
    selectedLocation.value = null;
    selectedPriceRange.value = null;
    selectedSortOption.value = 'date_desc';

    propertyFilter.value = PropertyFilter(
      page: 1,
      pageSize: 10,
      sortBy: 'date',
      sortDirection: 'desc',
    );

    getAllProperties(refresh: true);
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    filteredProperties.value = properties;
  }
}