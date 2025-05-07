import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/app/data/models/property_model.dart';
import 'package:real_estate_app/app/data/repositories/property_repository.dart';
import 'package:real_estate_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/app/routes/app_pages.dart';
import 'package:real_estate_app/app/utils/constants.dart';
import 'package:real_estate_app/app/utils/helpers.dart';

class HomeController extends GetxController {
  final PropertyRepository _propertyRepository = Get.find<PropertyRepository>();
  final AuthController _authController = Get.find<AuthController>();

  // Featured properties
  final featuredProperties = <PropertyModel>[].obs;
  final recentProperties = <PropertyModel>[].obs;

  // Search controller
  final searchController = TextEditingController();

  // Loading states
  final isLoading = false.obs;

  // Navigation
  final currentIndex = 0.obs;
  final pageController = PageController();

  // Quick filters
  final selectedPropertyType = Rxn<String>();
  final selectedLocation = Rxn<String>();
  final selectedPriceRange = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }
  void onUserLoginStatusChanged() {
    update();
  }

  @override
  void onClose() {
    searchController.dispose();
    pageController.dispose();
    super.onClose();
  }

  // Load initial data
  Future<void> loadInitialData() async {
    await Future.wait([
      loadFeaturedProperties(),
      loadRecentProperties(),
    ]);
  }

  // Load featured properties
  Future<void> loadFeaturedProperties() async {
    try {
      isLoading.value = true;

      // Get properties sorted by price (high to low) as featured
      final filter = PropertyFilter(
        page: 1,
        pageSize: 5,
        sortBy: 'price',
        sortDirection: 'desc',
      );

      final response = await _propertyRepository.getAllProperties(filter);
      featuredProperties.value = response.properties;
    } catch (e) {
      print('Error loading featured properties: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Load recent properties
  Future<void> loadRecentProperties() async {
    try {
      isLoading.value = true;

      // Get latest properties
      final filter = PropertyFilter(
        page: 1,
        pageSize: 10,
        sortBy: 'date',
        sortDirection: 'desc',
      );

      final response = await _propertyRepository.getAllProperties(filter);
      recentProperties.value = response.properties;
    } catch (e) {
      print('Error loading recent properties: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Handle tab navigation
  void changeTab(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  // Handle search
  void handleSearch() {
    final query = searchController.text.trim();
    if (query.isNotEmpty) {
      Get.toNamed(Routes.PROPERTY_SEARCH, arguments: query);
    }
  }

  // View property details
  void viewPropertyDetails(String id) {
    Get.toNamed(Routes.PROPERTY_DETAIL.replaceAll(':id', id));
  }

  // Apply quick filter
  void applyQuickFilter() {
    final filter = PropertyFilter(
      propertyType: selectedPropertyType.value,
      location: selectedLocation.value,
      minPrice: selectedPriceRange.value?['min'],
      maxPrice: selectedPriceRange.value?['max'] == -1 ? null : selectedPriceRange.value?['max'],
    );

    Get.toNamed(Routes.PROPERTY_LIST, arguments: filter);
  }

  // Reset quick filters
  void resetQuickFilters() {
    selectedPropertyType.value = null;
    selectedLocation.value = null;
    selectedPriceRange.value = null;
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _authController.isLoggedIn();
  }

  // Get user data
  dynamic get userData => _authController.user.value;

  // Navigate to bookings
  void navigateToBookings() {
    if (isLoggedIn()) {
      Get.toNamed(Routes.BOOKING_LIST);
    } else {
      Get.toNamed(Routes.LOGIN);
    }
  }

  // Navigate to favorites
  void navigateToFavorites() {
    if (isLoggedIn()) {
      Get.toNamed(Routes.FAVORITES);
    } else {
      Get.toNamed(Routes.LOGIN);
    }
  }

  // Navigate to profile
  void navigateToProfile() {
    if (isLoggedIn()) {
      Get.toNamed(Routes.PROFILE);
    } else {
      Get.toNamed(Routes.LOGIN);
    }
  }

  // Logout
  Future<void> logout() async {
    await _authController.logout();
    update(); // Add this to notify GetBuilder widgets
  }
}