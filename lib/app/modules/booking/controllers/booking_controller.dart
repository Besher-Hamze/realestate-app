import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/app/data/models/booking_model.dart';
import 'package:real_estate_app/app/data/repositories/booking_repository.dart';
import 'package:real_estate_app/app/utils/helpers.dart';

class BookingController extends GetxController {
  final BookingRepository _bookingRepository = Get.find<BookingRepository>();

  // Form controllers
  final TextEditingController messageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Form key
  final bookingFormKey = GlobalKey<FormState>();

  // Bookings list
  final bookings = <BookingModel>[].obs;

  // Booking request
  final requestDate = DateTime.now().add(const Duration(days: 1)).obs;

  // Selected status filter
  final selectedStatus = Rxn<String>();

  // Pagination
  final totalPages = 0.obs;
  final currentPage = 1.obs;
  final totalCount = 0.obs;
  final pageSize = 10.obs;

  // Loading states
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserBookings();
  }

  @override
  void onClose() {
    messageController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // Get user bookings
  Future<void> getUserBookings({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
      }

      isLoading.value = true;

      final response = await _bookingRepository.getUserBookings(
        status: selectedStatus.value,
        page: currentPage.value,
        pageSize: pageSize.value,
      );

      if (refresh || currentPage.value == 1) {
        bookings.clear();
      }

      bookings.addAll(response.bookings);

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

  // Load more bookings (pagination)
  Future<void> loadMoreBookings() async {
    if (currentPage.value < totalPages.value && !isLoadingMore.value) {
      try {
        isLoadingMore.value = true;

        final nextPage = currentPage.value + 1;

        final response = await _bookingRepository.getUserBookings(
          status: selectedStatus.value,
          page: nextPage,
          pageSize: pageSize.value,
        );

        bookings.addAll(response.bookings);

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

  // Create booking request
  Future<bool> createBooking(String propertyId) async {
    if (!bookingFormKey.currentState!.validate()) {
      return false;
    }

    try {
      isSubmitting.value = true;

      final request = CreateBookingRequest(
        propertyId: propertyId,
        requestDate: requestDate.value,
        message: messageController.text,
        contactPhone: phoneController.text,
      );

      await _bookingRepository.createBooking(request);

      // Clear form fields
      messageController.clear();

      Helpers.showSuccessSnackbar(
        'تم إرسال الطلب',
        'سيتم التواصل معك قريبًا',
      );

      // Refresh bookings list
      await getUserBookings(refresh: true);

      return true;
    } catch (e) {
      Helpers.showErrorSnackbar('خطأ', e.toString());
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _bookingRepository.cancelBooking(bookingId);

      // Remove from local list
      bookings.removeWhere((booking) => booking.id == bookingId);

      Helpers.showSuccessSnackbar('تمت العملية', 'تم إلغاء طلب الحجز بنجاح');
    } catch (e) {
      Helpers.showErrorSnackbar('خطأ', e.toString());
    }
  }

  // Filter bookings by status
  void filterByStatus(String? status) {
    selectedStatus.value = status;
    getUserBookings(refresh: true);
  }

  // Set booking date
  void setBookingDate(DateTime date) {
    requestDate.value = date;
  }
}