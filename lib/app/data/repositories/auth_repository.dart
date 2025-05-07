import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:real_estate_app/app/data/models/auth_model.dart';
import 'package:real_estate_app/app/data/providers/api_provider.dart';

class AuthRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final GetStorage _storage = GetStorage();

  Future<LoginResponse> login(LoginRequest request) async {
    try {

      final response = await _apiProvider.post('/api/auth/login', data: request.toJson());
      if (response.statusCode==200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        // Save auth data to storage
        await _storage.write('token', loginResponse.token);
        await _storage.write('userId', loginResponse.userId);
        await _storage.write('username', loginResponse.username);
        await _storage.write('expiration', loginResponse.expiration.toIso8601String());
        return loginResponse;
      } else {
        throw response.data['message'] ?? 'فشل تسجيل الدخول';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل تسجيل الدخول';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiProvider.post('/api/auth/register', data: request.toJson());

      if (response.statusCode == 201) {
        return RegisterResponse.fromJson(response.data);
      } else {
        throw response.data['message'] ?? 'فشل تسجيل المستخدم';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل تسجيل المستخدم';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  Future<RefreshTokenResponse> refreshToken(String refreshToken) async {
    try {
      final request = RefreshTokenRequest(refreshToken: refreshToken);
      final response = await _apiProvider.post(
        '/api/auth/refresh-token',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final refreshResponse = RefreshTokenResponse.fromJson(response.data);

        // Update token in storage
        await _storage.write('token', refreshResponse.token);
        await _storage.write('expiration', refreshResponse.expiration.toIso8601String());

        return refreshResponse;
      } else {
        throw response.data['message'] ?? 'فشل تحديث الرمز';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'فشل تحديث الرمز';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  Future<void> logout() async {
    await _storage.erase();
  }

  bool isLoggedIn() {
    final token = _storage.read('token');
    final expiration = _storage.read('expiration');

    if (token == null || expiration == null) {
      return false;
    }

    final expirationDate = DateTime.parse(expiration);
    return expirationDate.isAfter(DateTime.now());
  }

  String? getToken() {
    return _storage.read('token');
  }

  String? getUserId() {
    return _storage.read('userId');
  }

  String? getUsername() {
    return _storage.read('username');
  }
}