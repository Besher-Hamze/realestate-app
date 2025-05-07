import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/app/data/models/property_model.dart';
import 'package:real_estate_app/app/data/providers/api_provider.dart';

class PropertyRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<PropertyListResponse> getAllProperties(PropertyFilter filter) async {
    try {
      final response = await _apiProvider.get(
        '/api/properties',
        queryParameters: filter.toJson(),
      );
      if (response.statusCode == 200) {
        print("=====================================================");
        return PropertyListResponse.fromJson(response.data);
      } else {
        throw response.data['message'] ?? 'فشل الحصول على العقارات';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل الحصول على العقارات';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  Future<PropertyListResponse> searchProperties(String query, {int page = 1, int pageSize = 10}) async {
    try {
      final response = await _apiProvider.get(
        '/api/properties/search',
        queryParameters: {
          'query': query,
          'page': page,
          'pageSize': pageSize,
        },
      );

      if (response.statusCode == 200) {
        return PropertyListResponse.fromJson(response.data);
      } else {
        throw response.data['message'] ?? 'فشل البحث عن العقارات';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل البحث عن العقارات';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  Future<PropertyModel> getPropertyDetails(String id) async {
    try {
      final response = await _apiProvider.get('/api/properties/$id');

      if (response.statusCode == 200) {
        return PropertyModel.fromJson(response.data);
      } else {
        throw response.data['message'] ?? 'فشل الحصول على تفاصيل العقار';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل الحصول على تفاصيل العقار';
        throw errorMessage;
      }
      throw e.toString();
    }
  }
}