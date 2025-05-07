import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/app/data/models/booking_model.dart';
import 'package:real_estate_app/app/data/providers/api_provider.dart';

class BookingRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<BookingModel> createBooking(CreateBookingRequest request) async {
    try {
      final response = await _apiProvider.post(
        '/api/bookings',
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        return BookingModel.fromJson(response.data);
      } else {
        throw response.data['message'] ?? 'فشل إنشاء طلب الحجز';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل إنشاء طلب الحجز';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  Future<BookingListResponse> getUserBookings({
    String? status,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
      };

      if (status != null) {
        queryParams['status'] = status;
      }

      final response = await _apiProvider.get(
        '/api/bookings/user',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return BookingListResponse.fromJson(response.data);
      } else {
        throw response.data['message'] ?? 'فشل الحصول على طلبات الحجز';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل الحصول على طلبات الحجز';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      final response = await _apiProvider.delete('/api/bookings/$bookingId');

      if (response.statusCode == 200) {
        return response.data['success'] ?? false;
      } else {
        throw response.data['message'] ?? 'فشل إلغاء طلب الحجز';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل إلغاء طلب الحجز';
        throw errorMessage;
      }
      throw e.toString();
    }
  }
}