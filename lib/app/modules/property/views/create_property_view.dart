  import 'dart:io';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:google_maps_flutter/google_maps_flutter.dart';
  import 'package:real_estate_app/app/modules/property/controllers/create_property_controller.dart';
  import 'package:real_estate_app/app/utils/constants.dart';
  import 'package:real_estate_app/app/utils/theme.dart';

  class CreatePropertyView extends GetView<CreatePropertyController> {
    const CreatePropertyView({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('إضافة عقار جديد'),
          elevation: 0,
          centerTitle: true,
          actions: [
            // Save Draft Button
            IconButton(
              onPressed: controller.saveDraft,
              icon: const Icon(Icons.drafts_outlined),
              tooltip: 'حفظ كمسودة',
            ),

            // Publish Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Obx(() => ElevatedButton(
                onPressed:  !controller.isSubmitting.value
                    ? controller.createProperty
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: controller.isSubmitting.value
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'نشر',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              )),
            ),
          ],
        ),
        body: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Social Media Style Header
                _buildSocialHeader(),
                const SizedBox(height: 24),

                // Image Upload Section (Most Important for Social Media)
                _buildImageUploadSection(),
                const SizedBox(height: 24),

                // Property Details
                _buildPropertyDetailsSection(),
                const SizedBox(height: 24),

                // Location Section
                _buildLocationSection(),
                const SizedBox(height: 24),

                // Features Section
                _buildFeaturesSection(),
                const SizedBox(height: 24),

                // Availability Section
                _buildAvailabilitySection(),
                const SizedBox(height: 100), // Extra space for FAB
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildSocialHeader() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إضافة عقار جديد',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'شارك عقارك مع المجتمع',
                    style: TextStyle(
                      color: AppTheme.secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'عام',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildImageUploadSection() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.photo_library_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'صور العقار',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Obx(() => Text(
                  '${controller.selectedImages.length}/10',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 12,
                  ),
                )),
              ],
            ),
            const SizedBox(height: 12),

            // Image Grid
            Obx(() {
              if (controller.selectedImages.isEmpty) {
                return _buildImageUploadPlaceholder();
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: controller.selectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.selectedImages.length) {
                    return _buildAddImageButton();
                  }

                  return _buildImageItem(controller.selectedImages[index], index);
                },
              );
            }),
          ],
        ),
      );
    }

    Widget _buildImageUploadPlaceholder() {
      return GestureDetector(
        onTap: _showImagePickerOptions,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 48,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                'اضغط لإضافة صور',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'يمكنك إضافة حتى 10 صور',
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildAddImageButton() {
      return GestureDetector(
        onTap: controller.selectedImages.length < 10 ? _showImagePickerOptions : null,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                size: 32,
                color: controller.selectedImages.length < 10
                    ? AppTheme.primaryColor
                    : AppTheme.secondaryTextColor,
              ),
              const SizedBox(height: 4),
              Text(
                'إضافة',
                style: TextStyle(
                  color: controller.selectedImages.length < 10
                      ? AppTheme.primaryColor
                      : AppTheme.secondaryTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildImageItem(File image, int index) {
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main image indicator
          if (index == 0)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'رئيسية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Remove button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => controller.removeImage(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget _buildPropertyDetailsSection() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.home_work_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'تفاصيل العقار',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            TextFormField(
              controller: controller.titleController,
              decoration: const InputDecoration(
                labelText: 'عنوان العقار *',
                hintText: 'مثال: شقة فاخرة للإيجار في الرياض',
                prefixIcon: Icon(Icons.title_rounded),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال عنوان العقار';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: controller.descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'وصف العقار *',
                hintText: 'اكتب وصفاً مفصلاً عن العقار ومميزاته...',
                prefixIcon: Icon(Icons.description_rounded),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال وصف العقار';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Property Type
            const Text(
              'نوع العقار *',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => Wrap(
              spacing: 8,
              children: Constants.propertyTypes.entries.map((entry) {
                final isSelected = controller.selectedPropertyType.value == entry.key;
                return ChoiceChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      controller.selectPropertyType(entry.key);
                    }
                  },
                  selectedColor: AppTheme.primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            )),
            const SizedBox(height: 16),

            // Price and Area Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'السعر (ريال) *',
                      prefixIcon: Icon(Icons.monetization_on_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال السعر';
                      }
                      if (int.tryParse(value) == null) {
                        return 'الرجاء إدخال رقم صحيح';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: controller.areaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'المساحة (م²) *',
                      prefixIcon: Icon(Icons.straighten_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال المساحة';
                      }
                      if (double.tryParse(value) == null) {
                        return 'الرجاء إدخال رقم صحيح';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Bedrooms and Bathrooms
            Row(
              children: [
                Expanded(
                  child: _buildCounterField(
                    'غرف النوم',
                    controller.selectedBedrooms,
                    Icons.king_bed_rounded,
                    0,
                    20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCounterField(
                    'الحمامات',
                    controller.selectedBathrooms,
                    Icons.shower_rounded,
                    1,
                    10,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget _buildCounterField(String label, RxInt value, IconData icon, int min, int max) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.dividerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: value.value > min
                      ? () => value.value--
                      : null,
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 20, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Obx(() => Text(
                          '${value.value}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: value.value < max
                      ? () => value.value++
                      : null,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget _buildLocationSection() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'الموقع',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // City Selection
            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedLocationCity.value.isEmpty ? null : controller.selectedLocationCity.value,
              decoration: const InputDecoration(
                labelText: 'المدينة *',
                prefixIcon: Icon(Icons.location_city_rounded),
              ),
              items: Constants.cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedLocationCity.value = value;
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء اختيار المدينة';
                }
                return null;
              },
            )),
            const SizedBox(height: 16),

            // Address
            TextFormField(
              controller: controller.addressController,
              decoration: const InputDecoration(
                labelText: 'العنوان التفصيلي',
                hintText: 'مثال: شارع الملك فهد، حي العليا',
                prefixIcon: Icon(Icons.home_rounded),
              ),
            ),
            const SizedBox(height: 16),

            // Map Selection
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Obx(() => GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: controller.selectedCoordinates.value,
                        zoom: 14,
                      ),
                      onTap: (LatLng coordinates) {
                        controller.updateLocation(coordinates);
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId('property'),
                          position: controller.selectedCoordinates.value,
                          draggable: true,
                          onDragEnd: (LatLng coordinates) {
                            controller.updateLocation(coordinates);
                          },
                        ),
                      },
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                    )),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: controller.getCurrentLocation,
                          icon: Obx(() => controller.isLoadingLocation.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.my_location_rounded)),
                          tooltip: 'موقعي الحالي',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'اضغط على الخريطة أو اسحب العلامة لتحديد الموقع الدقيق',
              style: TextStyle(
                color: AppTheme.secondaryTextColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildFeaturesSection() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'المميزات',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'اختر المميزات المتوفرة في العقار',
              style: TextStyle(
                color: AppTheme.secondaryTextColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),

            Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Constants.propertyFeatures.map((feature) {
                final isSelected = controller.selectedFeatures.contains(feature);
                return FilterChip(
                  label: Text(feature),
                  selected: isSelected,
                  onSelected: (selected) {
                    controller.toggleFeature(feature);
                  },
                  selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                  checkmarkColor: AppTheme.primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
                  ),
                );
              }).toList(),
            )),
          ],
        ),
      );
    }

    Widget _buildAvailabilitySection() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.roundabout_left,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'نوع العرض',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // For Rent Toggle
            Obx(() => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: controller.isForRent.value
                      ? AppTheme.primaryColor
                      : AppTheme.dividerColor,
                ),
                color: controller.isForRent.value
                    ? AppTheme.primaryColor.withOpacity(0.05)
                    : Colors.transparent,
              ),
              child: CheckboxListTile(
                title: const Text(
                  'للإيجار',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: const Text('متاح للإيجار الشهري/السنوي'),
                value: controller.isForRent.value,
                onChanged: (value) => controller.toggleForRent(value ?? false),
                activeColor: AppTheme.primaryColor,
                secondary: Icon(
                  Icons.calendar_month_rounded,
                  color: controller.isForRent.value
                      ? AppTheme.primaryColor
                      : AppTheme.secondaryTextColor,
                ),
              ),
            )),
            const SizedBox(height: 12),

            // Rental Duration (only if for rent)
            Obx(() => controller.isForRent.value
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مدة الإيجار (بالأشهر)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: controller.rentalDurationMonths.value.toDouble(),
                              min: 1,
                              max: 60,
                              divisions: 59,
                              label: '${controller.rentalDurationMonths.value} شهر',
                              onChanged: (value) {
                                controller.rentalDurationMonths.value = value.toInt();
                              },
                              activeColor: AppTheme.primaryColor,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Obx(() => Text(
                              '${controller.rentalDurationMonths.value} شهر',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  )
                : const SizedBox.shrink()),

            // For Sale Toggle
            Obx(() => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: controller.isForSale.value
                      ? AppTheme.primaryColor
                      : AppTheme.dividerColor,
                ),
                color: controller.isForSale.value
                    ? AppTheme.primaryColor.withOpacity(0.05)
                    : Colors.transparent,
              ),
              child: CheckboxListTile(
                title: const Text(
                  'للبيع',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: const Text('متاح للبيع بشكل نهائي'),
                value: controller.isForSale.value,
                onChanged: (value) => controller.toggleForSale(value ?? false),
                activeColor: AppTheme.primaryColor,
                secondary: Icon(
                  Icons.sell_rounded,
                  color: controller.isForSale.value
                      ? AppTheme.primaryColor
                      : AppTheme.secondaryTextColor,
                ),
              ),
            )),
          ],
        ),
      );
    }

    void _showImagePickerOptions() {
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'إضافة صور',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildImageOptionButton(
                      icon: Icons.photo_library_rounded,
                      label: 'من المعرض',
                      onTap: () {
                        Get.back();
                        controller.pickImages();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildImageOptionButton(
                      icon: Icons.camera_alt_rounded,
                      label: 'التقاط صورة',
                      onTap: () {
                        Get.back();
                        controller.pickImageFromCamera();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildImageOptionButton({
      required IconData icon,
      required String label,
      required VoidCallback onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }