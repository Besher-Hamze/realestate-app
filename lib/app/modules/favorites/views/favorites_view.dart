import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:real_estate_app/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:real_estate_app/app/utils/constants.dart';
import 'package:real_estate_app/app/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:real_estate_app/app/utils/helpers.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'),
      ),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : _buildFavoritesList(),
      ),
    );
  }

  Widget _buildFavoritesList() {
    final RefreshController refreshController = RefreshController();

    return Obx(() {
      if (controller.favorites.isEmpty) {
        return _buildEmptyState();
      }

      return SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        enablePullUp: controller.currentPage.value < controller.totalPages.value,
        header: const WaterDropHeader(),
        footer: const ClassicFooter(
          loadingText: 'جاري التحميل...',
          canLoadingText: 'اسحب للأعلى لتحميل المزيد',
          idleText: 'اسحب للأعلى لتحميل المزيد',
          noDataText: 'لا توجد المزيد من العقارات',
        ),
        onRefresh: () async {
          await controller.getFavorites(refresh: true);
          refreshController.refreshCompleted();
        },
        onLoading: () async {
          await controller.loadMoreFavorites();
          refreshController.loadComplete();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.favorites.length,
          itemBuilder: (context, index) {
            final favorite = controller.favorites[index];
            return _buildFavoriteCard(favorite);
          },
        ),
      );
    });
  }

  Widget _buildFavoriteCard(favorite) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => controller.viewPropertyDetails(favorite.propertyId),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image with remove button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: "${Constants.baseUrl}/${favorite.property.mainImageUrl}",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        // Show confirmation dialog
                        Get.defaultDialog(
                          title: 'إزالة من المفضلة',
                          middleText: 'هل تريد إزالة هذا العقار من المفضلة؟',
                          textConfirm: 'إزالة',
                          textCancel: 'إلغاء',
                          confirmTextColor: Colors.white,
                          cancelTextColor: AppTheme.primaryColor,
                          buttonColor: AppTheme.primaryColor,
                          onConfirm: () {
                            Get.back();
                            controller.removeFromFavorites(favorite.propertyId);
                          },
                        );
                      },
                    ),
                  ),
                ),

                // Availability badge
                if (!favorite.property.isAvailable)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: Text(
                          'غير متاح',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Property Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    favorite.property.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppTheme.secondaryTextColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          favorite.property.location,
                          style: const TextStyle(
                            color: AppTheme.secondaryTextColor,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Text(
                    Helpers.formatCurrency(favorite.property.price),
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Added date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: AppTheme.secondaryTextColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'أضيف ${Helpers.formatRelativeTime(favorite.addedAt)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد عقارات في المفضلة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'أضف العقارات المفضلة لديك للوصول إليها بسهولة',
            style: TextStyle(
              color: AppTheme.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.home),
            label: const Text('استعرض العقارات'),
          ),
        ],
      ),
    );
  }
}