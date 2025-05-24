import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/app/modules/home/controllers/home_controller.dart';
import 'package:real_estate_app/app/utils/constants.dart';
import 'package:real_estate_app/app/utils/theme.dart';

class QuickFilterWidget extends GetView<HomeController> {
  const QuickFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.filter_alt_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'البحث السريع',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: controller.resetQuickFilters,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh,
                          size: 14,
                          color: AppTheme.primaryColor.withOpacity(0.8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'إعادة تعيين',
                          style: TextStyle(
                            color: AppTheme.primaryColor.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Filter Category Labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 16,
              children: [
                _buildCategoryLabel('نوع العقار', Icons.home_rounded),
                _buildCategoryLabel('الموقع', Icons.location_on_rounded),
                _buildCategoryLabel('السعر', Icons.monetization_on_rounded),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Property Type Filter
          Obx(() => Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  _buildFilterChip(
                    label: 'الكل',
                    selected: controller.selectedPropertyType.value == null,
                    onSelected: (_) => controller.selectedPropertyType.value = null,
                  ),
                  ...Constants.propertyTypes.entries.map((entry) {
                    return _buildFilterChip(
                      label: entry.value,
                      selected: controller.selectedPropertyType.value == entry.key,
                      onSelected: (_) => controller.selectedPropertyType.value = entry.key,
                      icon: _getPropertyTypeIcon(entry.key),
                    );
                  }),
                ],
              ),
            ),
          )),

          // Location Filter
          Obx(() => Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  _buildFilterChip(
                    label: 'كل المدن',
                    selected: controller.selectedLocation.value == null,
                    onSelected: (_) => controller.selectedLocation.value = null,
                    icon: Icons.location_on_rounded,
                  ),
                  ...Constants.cities.take(5).map((city) {
                    return _buildFilterChip(
                      label: city,
                      selected: controller.selectedLocation.value == city,
                      onSelected: (_) => controller.selectedLocation.value = city,
                      icon: Icons.location_city_rounded,
                    );
                  }),
                ],
              ),
            ),
          )),

          // Price Range Filter
          Obx(() => Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  _buildFilterChip(
                    label: 'كل الأسعار',
                    selected: controller.selectedPriceRange.value == null,
                    onSelected: (_) => controller.selectedPriceRange.value = null,
                    icon: Icons.monetization_on_rounded,
                  ),
                  ...Constants.priceRanges.take(3).map((range) {
                    return _buildFilterChip(
                      label: range['label'],
                      selected: controller.selectedPriceRange.value == range,
                      onSelected: (_) => controller.selectedPriceRange.value = range,
                      icon: Icons.monetization_on_rounded,
                    );
                  }),
                ],
              ),
            ),
          )),

          // Apply Filter Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: controller.applyQuickFilter,
              icon: const Icon(Icons.search, size: 20),
              label: const Text('عرض النتائج'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLabel(String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: AppTheme.secondaryTextColor,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required ValueChanged<bool> onSelected,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? Colors.white : AppTheme.primaryColor,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        selected: selected,
        onSelected: onSelected,
        selectedColor: AppTheme.primaryColor,
        backgroundColor: Colors.white,
        checkmarkColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppTheme.textColor,
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? AppTheme.primaryColor : AppTheme.dividerColor,
            width: 1,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }

  IconData _getPropertyTypeIcon(int type) {
    switch (type) {
      case 1:
        return Icons.apartment_rounded;
      case 2:
        return Icons.home_rounded;
      case 3:
        return Icons.landscape_rounded;
      case 4:
        return Icons.business_rounded;
      case 5:
        return Icons.store_rounded;
      default:
        return Icons.home_work_rounded;
    }
  }
}