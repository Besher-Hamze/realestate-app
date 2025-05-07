import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/app/modules/home/views/widgets/property_card.dart';
import 'package:real_estate_app/app/modules/property/controllers/property_controller.dart';
import 'package:real_estate_app/app/utils/theme.dart';

class PropertySearchView extends GetView<PropertyController> {
  const PropertySearchView({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if search query was passed as argument
    if (Get.arguments != null && Get.arguments is String) {
      controller.searchController.text = Get.arguments as String;
      controller.searchProperties(controller.searchController.text);
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller.searchController,
          autofocus: controller.searchController.text.isEmpty,
          decoration: InputDecoration(
            hintText: 'ابحث عن عقار...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                controller.searchController.clear();
                controller.clearSearch();
              },
            ),
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              controller.searchProperties(value);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (controller.searchController.text.isNotEmpty) {
                controller.searchProperties(controller.searchController.text);
              }
            },
          ),
        ],
      ),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : _buildSearchResults(),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Obx(() {
      if (controller.searchQuery.value.isEmpty) {
        return _buildInitialState();
      }

      if (controller.filteredProperties.isEmpty) {
        return _buildEmptyResultsState();
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.filteredProperties.length,
        itemBuilder: (context, index) {
          final property = controller.filteredProperties[index];
          return PropertyCard(
            property: property,
            onTap: () => controller.getPropertyDetails(property.id),
          );
        },
      );
    });
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'البحث عن عقارات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'ابحث عن عقارات بالموقع، النوع، أو المواصفات',
            style: TextStyle(
              color: AppTheme.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyResultsState() {
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
            'لا توجد نتائج',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على عقارات تطابق "${controller.searchQuery.value}"',
            style: const TextStyle(
              color: AppTheme.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.clearSearch(),
            icon: const Icon(Icons.refresh),
            label: const Text('محاولة بحث آخر'),
          ),
        ],
      ),
    );
  }
}