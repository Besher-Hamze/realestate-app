import 'package:get/get.dart';
import 'package:real_estate_app/app/data/models/favorite_model.dart';
import 'package:real_estate_app/app/data/repositories/favorite_repository.dart';
import 'package:real_estate_app/app/routes/app_pages.dart';
import 'package:real_estate_app/app/utils/helpers.dart';

class FavoritesController extends GetxController {
  final FavoriteRepository _favoriteRepository = Get.find<FavoriteRepository>();

  // Favorites list
  final favorites = <FavoriteModel>[].obs;

  // Pagination
  final totalPages = 0.obs;
  final currentPage = 1.obs;
  final totalCount = 0.obs;
  final pageSize = 10.obs;

  // Loading states
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    getFavorites();
  }

  // Get favorites
  Future<void> getFavorites({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
      }

      isLoading.value = true;

      final response = await _favoriteRepository.getFavoriteProperties(
        page: currentPage.value,
        pageSize: pageSize.value,
      );

      if (refresh || currentPage.value == 1) {
        favorites.clear();
      }

      favorites.addAll(response.favorites);

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

  // Load more favorites (pagination)
  Future<void> loadMoreFavorites() async {
    if (currentPage.value < totalPages.value && !isLoadingMore.value) {
      try {
        isLoadingMore.value = true;

        final nextPage = currentPage.value + 1;

        final response = await _favoriteRepository.getFavoriteProperties(
          page: nextPage,
          pageSize: pageSize.value,
        );

        favorites.addAll(response.favorites);

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

  // Remove from favorites
  Future<void> removeFromFavorites(String propertyId) async {
    try {
      await _favoriteRepository.removeFromFavorites(propertyId);

      // Remove from local list
      favorites.removeWhere((favorite) => favorite.propertyId == propertyId);

      Helpers.showSuccessSnackbar('تمت العملية', 'تمت إزالة العقار من المفضلة');
    } catch (e) {
      Helpers.showErrorSnackbar('خطأ', e.toString());
    }
  }

  // View property details
  void viewPropertyDetails(String propertyId) {
    Get.toNamed(Routes.PROPERTY_DETAIL.replaceAll(':id', propertyId));
  }
}