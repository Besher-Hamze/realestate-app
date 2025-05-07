import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:real_estate_app/app/data/models/auth_model.dart';
import 'package:real_estate_app/app/data/models/user_model.dart';
import 'package:real_estate_app/app/data/providers/api_provider.dart';

class UserRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final GetStorage _storage = GetStorage();

  Future<UserModel> getUserProfile() async {
    try {
      final response = await _apiProvider.get('/api/users/profile');

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data);
        // Cache user profile
        await _storage.write('userProfile', response.data);
        return user;
      } else {
        throw response.data['message'] ?? 'فشل الحصول على الملف الشخصي';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل الحصول على الملف الشخصي';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  Future<UserModel> updateUserProfile({
    required String fullName,
    required String phoneNumber,
    required String email,
  }) async {
    try {
      final data = {
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'email': email,
      };

      final response = await _apiProvider.put(
        '/api/users/profile',
        data: data,
      );

      if (response.statusCode == 200) {
        final updatedProfile = UserModel.fromJson(response.data['profile']);
        // Update cached user profile
        await _storage.write('userProfile', response.data['profile']);
        return updatedProfile;
      } else {
        throw response.data['message'] ?? 'فشل تحديث الملف الشخصي';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل تحديث الملف الشخصي';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  Future<bool> changePassword(ChangePasswordRequest request) async {
    try {
      final response = await _apiProvider.put(
        '/api/users/change-password',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return response.data['success'] ?? false;
      } else {
        throw response.data['message'] ?? 'فشل تغيير كلمة المرور';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل تغيير كلمة المرور';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  UserModel? getCachedProfile() {
    final cachedProfile = _storage.read('userProfile');
    if (cachedProfile != null) {
      return UserModel.fromJson(cachedProfile);
    }
    return null;
  }
}