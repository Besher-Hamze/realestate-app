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
      // Since there's no dedicated search endpoint, use the main properties endpoint with query parameter
      final response = await _apiProvider.get(
        '/api/properties',
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

  // Missing method: Create Property
  Future createProperty(dynamic propertyData) async {
    try {
      final response = await _apiProvider.post(
        '/api/properties/with-images',
        data: propertyData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw response.data['message'] ?? 'فشل في إنشاء العقار';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل في إنشاء العقار';
        throw errorMessage;
      }
      throw e.toString();
    }
  }
  // Missing method: Upload Image
  Future<Map<String, dynamic>> uploadImage(Map<String, dynamic> imageData) async {
    try {
      final response = await _apiProvider.post(
        '/api/images/upload',
        data: imageData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw response.data['message'] ?? 'فشل في رفع الصورة';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل في رفع الصورة';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  // Additional method: Update Property
  Future<Map<String, dynamic>> updateProperty(String propertyId, Map<String, dynamic> propertyData) async {
    try {
      final response = await _apiProvider.put(
        '/api/properties/$propertyId',
        data: propertyData,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw response.data['message'] ?? 'فشل في تحديث العقار';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل في تحديث العقار';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  // Additional method: Delete Property
  Future<bool> deleteProperty(String propertyId) async {
    try {
      final response = await _apiProvider.delete(
        '/api/properties/$propertyId',
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل في حذف العقار';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  // Additional method: Get Property Images
  Future<List<dynamic>> getPropertyImages(String propertyId) async {
    try {
      final response = await _apiProvider.get('/api/images/property/$propertyId');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw response.data['message'] ?? 'فشل في الحصول على صور العقار';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل في الحصول على صور العقار';
        throw errorMessage;
      }
      throw e.toString();
    }
  }
}