import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:real_estate_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:real_estate_app/app/routes/app_pages.dart';
import 'package:real_estate_app/app/utils/constants.dart';
import 'package:real_estate_app/app/utils/helpers.dart';
import 'package:real_estate_app/app/utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookingListView extends GetView<BookingController> {
  const BookingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حجوزاتي'),
      ),
      body: Column(
        children: [
          // Status filter
          _buildStatusFilter(),

          // Bookings list
          Expanded(
            child: Obx(
                  () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : _buildBookingsList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() => Row(
          children: [
            _buildFilterChip(
              label: 'الكل',
              selected: controller.selectedStatus.value == null,
              onSelected: (_) => controller.filterByStatus(null),
            ),
            _buildFilterChip(
              label: 'في الانتظار',
              selected: controller.selectedStatus.value == 0,
              onSelected: (_) => controller.filterByStatus(0),
              color: Colors.orange,
            ),
            _buildFilterChip(
              label: 'موافق عليه',
              selected: controller.selectedStatus.value == 1,
              onSelected: (_) => controller.filterByStatus(1),
              color: Colors.green,
            ),
            _buildFilterChip(
              label: 'مرفوض',
              selected: controller.selectedStatus.value == 2,
              onSelected: (_) => controller.filterByStatus(2),
              color: Colors.red,
            ),
            _buildFilterChip(
              label: 'ملغي',
              selected: controller.selectedStatus.value == 3,
              onSelected: (_) => controller.filterByStatus(3),
              color: Colors.grey,
            ),
            _buildFilterChip(
              label: 'مكتمل',
              selected: controller.selectedStatus.value == 4,
              onSelected: (_) => controller.filterByStatus(4),
              color: Colors.blue,
            ),
          ],
        )),
      ),
    );
  }
  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required ValueChanged<bool> onSelected,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        selectedColor: color ?? AppTheme.primaryColor,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppTheme.textColor,
        ),
        checkmarkColor: Colors.white,
      ),
    );
  }

  Widget _buildBookingsList() {
    final RefreshController refreshController = RefreshController();

    return Obx(() {
      if (controller.bookings.isEmpty) {
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
          noDataText: 'لا توجد المزيد من الحجوزات',
        ),
        onRefresh: () async {
          await controller.getUserBookings(refresh: true);
          refreshController.refreshCompleted();
        },
        onLoading: () async {
          await controller.loadMoreBookings();
          refreshController.loadComplete();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.bookings.length,
          itemBuilder: (context, index) {
            final booking = controller.bookings[index];
            return _buildBookingCard(booking);
          },
        ),
      );
    });
  }

  Widget _buildBookingCard(booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Helpers.getBookingStatusColor(booking.status),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Helpers.formatBookingStatus(booking.status),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'رقم الطلب: ${booking.id.substring(0, 8)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Property info
          InkWell(
            onTap: () => booking.propertyId != null
                ? Get.toNamed(Routes.PROPERTY_DETAIL.replaceAll(':id', booking.propertyId))
                : null,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property image
                  if (booking.property != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: CachedNetworkImage(
                          imageUrl: "${Constants.baseUrl}/${booking.property!.mainImageUrl}",
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
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
                    )
                  else
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.home_outlined,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    ),

                  const SizedBox(width: 12),

                  // Property details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (booking.property != null) ...[
                          Text(
                            booking.property!.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
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
                                  booking.property!.location,
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
                          const SizedBox(height: 4),
                          Text(
                            Helpers.formatCurrency(booking.property!.price),
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ] else ...[
                          Text(
                            'عقار #${booking.propertyId.substring(0, 8)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'تفاصيل العقار غير متوفرة',
                            style: TextStyle(
                              color: AppTheme.secondaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

          // Booking details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Appointment date
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'موعد المعاينة: ${Helpers.formatDate(booking.requestDate)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Request date
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'تاريخ الطلب: ${Helpers.formatDate(booking.createdAt)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Message
                if (booking.message.isNotEmpty) ...[
                  const Text(
                    'الرسالة:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.message,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                ],

                // Actions
                if (booking.status == 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          // Show confirmation dialog
                          Get.defaultDialog(
                            title: 'إلغاء الحجز',
                            middleText: 'هل أنت متأكد من إلغاء هذا الحجز؟',
                            textConfirm: 'نعم، إلغاء',
                            textCancel: 'تراجع',
                            confirmTextColor: Colors.white,
                            cancelTextColor: AppTheme.primaryColor,
                            buttonColor: Colors.red,
                            onConfirm: () {
                              Get.back();
                              controller.cancelBooking(booking.id);
                            },
                          );
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('إلغاء الحجز'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد حجوزات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'لم تقم بحجز أي معاينات للعقارات بعد',
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