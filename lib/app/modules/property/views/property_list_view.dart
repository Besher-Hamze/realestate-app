import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:real_estate_app/app/data/models/property_model.dart';
import 'package:real_estate_app/app/modules/home/views/widgets/property_card.dart';
import 'package:real_estate_app/app/modules/property/controllers/property_controller.dart';
import 'package:real_estate_app/app/utils/constants.dart';
import 'package:real_estate_app/app/utils/theme.dart';

class PropertyListView extends GetView<PropertyController> {
  const PropertyListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if filters were passed as arguments
    if (Get.arguments != null && Get.arguments is PropertyFilter) {
      controller.propertyFilter.value = Get.arguments as PropertyFilter;
      controller.getAllProperties(refresh: true);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('العقارات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : _buildPropertyList(),
      ),
    );
  }

  Widget _buildPropertyList() {
    final RefreshController refreshController = RefreshController();

    return Obx(() {
      if (controller.filteredProperties.isEmpty) {
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
          await controller.getAllProperties(refresh: true);
          refreshController.refreshCompleted();
        },
        onLoading: () async {
          await controller.loadMoreProperties();
          refreshController.loadComplete();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.filteredProperties.length,
          itemBuilder: (context, index) {
            final property = controller.filteredProperties[index];
            return PropertyCard(
              property: property,
              onTap: () => controller.getPropertyDetails(property.id),
            );
          },
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد عقارات متاحة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'حاول تغيير معايير البحث أو التصفية',
            style: TextStyle(
              color: AppTheme.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.resetFilters(),
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة تعيين الفلاتر'),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Obx(() => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'فلترة العقارات',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),

              // Property Type
              Text(
                'نوع العقار',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('الكل'),
                    selected: controller.selectedPropertyType.value == null,
                    onSelected: (selected) {
                      if (selected) {
                        controller.selectedPropertyType.value = null;
                      }
                    },
                  ),
                  // ...Constants.propertyTypes.map((type) {
                  //   String label;
                  //   switch (type) {
                  //     case 'apartment':
                  //       label = 'شقة';
                  //       break;
                  //     case 'villa':
                  //       label = 'فيلا';
                  //       break;
                  //     case 'land':
                  //       label = 'أرض';
                  //       break;
                  //     default:
                  //       label = type;
                  //   }
                  //   return ChoiceChip(
                  //     label: Text(label),
                  //     selected: controller.selectedPropertyType.value == type,
                  //     onSelected: (selected) {
                  //       if (selected) {
                  //         controller.selectedPropertyType.value = type;
                  //       } else {
                  //         controller.selectedPropertyType.value = null;
                  //       }
                  //     },
                  //   );
                  // }),
                ],
              ),
              const SizedBox(height: 16),

              // Bedrooms
              Text(
                'عدد الغرف',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('الكل'),
                    selected: controller.selectedBedrooms.value == null,
                    onSelected: (selected) {
                      if (selected) {
                        controller.selectedBedrooms.value = null;
                      }
                    },
                  ),
                  ...Constants.bedroomsOptions.take(5).map((bedrooms) {
                    return ChoiceChip(
                      label: Text('$bedrooms'),
                      selected: controller.selectedBedrooms.value == bedrooms,
                      onSelected: (selected) {
                        if (selected) {
                          controller.selectedBedrooms.value = bedrooms;
                        } else {
                          controller.selectedBedrooms.value = null;
                        }
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // Location
              Text(
                'الموقع',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('الكل'),
                    selected: controller.selectedLocation.value == null,
                    onSelected: (selected) {
                      if (selected) {
                        controller.selectedLocation.value = null;
                      }
                    },
                  ),
                  ...Constants.cities.map((city) {
                    return ChoiceChip(
                      label: Text(city),
                      selected: controller.selectedLocation.value == city,
                      onSelected: (selected) {
                        if (selected) {
                          controller.selectedLocation.value = city;
                        } else {
                          controller.selectedLocation.value = null;
                        }
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // Price Range
              Text(
                'نطاق السعر',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('الكل'),
                    selected: controller.selectedPriceRange.value == null,
                    onSelected: (selected) {
                      if (selected) {
                        controller.selectedPriceRange.value = null;
                      }
                    },
                  ),
                  ...Constants.priceRanges.map((range) {
                    return ChoiceChip(
                      label: Text(range['label']),
                      selected: controller.selectedPriceRange.value == range,
                      onSelected: (selected) {
                        if (selected) {
                          controller.selectedPriceRange.value = range;
                        } else {
                          controller.selectedPriceRange.value = null;
                        }
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // Sort Options
              Text(
                'ترتيب حسب',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: Constants.sortOptions.entries.map((entry) {
                  return ChoiceChip(
                    label: Text(entry.value),
                    selected: controller.selectedSortOption.value == entry.key,
                    onSelected: (selected) {
                      if (selected) {
                        controller.selectedSortOption.value = entry.key;
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => controller.resetFilters(),
                      child: const Text('إعادة تعيين'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.applyFilters();
                        Get.back();
                      },
                      child: const Text('تطبيق'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
      isScrollControlled: true,
      enableDrag: true,
    );
  }
}