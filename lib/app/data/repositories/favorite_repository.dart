import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/app/data/models/favorite_model.dart';
import 'package:real_estate_app/app/data/providers/api_provider.dart';

class FavoriteRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<FavoriteListResponse> getFavoriteProperties({int page = 1, int pageSize = 10}) async {
    try {
      final response = await _apiProvider.get(
        '/api/favorites',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
      );

      if (response.statusCode == 200) {
        return FavoriteListResponse.fromJson(response.data);
      } else {
        throw response.data['message'] ?? 'فشل الحصول على المفضلة';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل الحصول على المفضلة';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  Future<bool> addToFavorites(String propertyId) async {
    try {
      final response = await _apiProvider.post('/api/favorites/$propertyId');

      if (response.statusCode == 201) {
        return response.data['success'] ?? false;
      } else {
        throw response.data['message'] ?? 'فشل إضافة العقار إلى المفضلة';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل إضافة العقار إلى المفضلة';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  Future<bool> removeFromFavorites(String propertyId) async {
    try {
      final response = await _apiProvider.delete('/api/favorites/$propertyId');

      if (response.statusCode == 200) {
        return response.data['success'] ?? false;
      } else {
        throw response.data['message'] ?? 'فشل إزالة العقار من المفضلة';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل إزالة العقار من المفضلة';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  Future<bool> isFavorite(String propertyId) async {
    try {
      final favorites = await getFavoriteProperties();
      return favorites.favorites.any((favorite) => favorite.propertyId == propertyId);
    } catch (e) {
      return false;
    }
  }
}