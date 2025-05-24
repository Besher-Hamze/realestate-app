import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response,FormData;
import 'package:get_storage/get_storage.dart';
import 'package:real_estate_app/app/utils/constants.dart';

class ApiProvider {
  late Dio _dio;
  final storage = GetStorage();

  ApiProvider() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "http://192.168.74.4:5268",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        contentType: Headers.jsonContentType,
        headers: {
          'Accept': 'application/json',
        },
        followRedirects: true,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    _initializeInterceptors();
  }

  // Getter to access Dio instance directly for FormData uploads
  Dio get dio => _dio;

  // Getter to access auth token
  String? get authToken => storage.read('token');

  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = storage.read('token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          if (kDebugMode) {
            print('REQUEST[${options.method}] => PATH: ${options.path}');
            print('REQUEST HEADERS => ${options.headers}');
            print('REQUEST BODY => ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
            print('RESPONSE DATA TYPE => ${response.data.runtimeType}');
            print('RESPONSE DATA => ${response.data}');
          }

          return handler.next(response);
        },
        onError: (DioException error, handler) {
          if (kDebugMode) {
            print('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
            print('ERROR DATA => ${error.response?.data}');
          }

          // Handle token expiration
          if (error.response?.statusCode == 401) {
            // Call refresh token endpoint or logout
            _refreshToken();
          }

          return handler.next(error);
        },
      ),
    );
  }

  Future<void> _refreshToken() async {
    try {
      final refreshToken = storage.read('refreshToken');

      if (refreshToken != null) {
        final response = await _dio.post(
          '/api/auth/refresh-token',
          data: {
            'refreshToken': refreshToken,
          },
        );

        if (response.statusCode == 200) {
          final token = response.data['token'];
          final expiration = response.data['expiration'];

          await storage.write('token', token);
          await storage.write('expiration', expiration);
        } else {
          // Logout if refresh token is invalid
          await _logout();
        }
      } else {
        await _logout();
      }
    } catch (e) {
      await _logout();
    }
  }

  Future<void> _logout() async {
    await storage.erase();
    Get.offAllNamed('/login');
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Updated post method with options parameter support
  Future<Response> post(String path, {dynamic data, Options? options}) async {
    try {
      print('📤 REQUEST URL: ${_dio.options.baseUrl}$path');
      print('📤 REQUEST BODY: $data');

      // Use provided options or create default ones
      final requestOptions = options ?? Options(
        contentType: Headers.jsonContentType,
        headers: {'Accept': 'application/json'},
      );

      // Try first with provided or standard JSON content type
      var response = await _dio.post(
        path,
        data: data,
        options: requestOptions,
      );

      // If we get empty response, try with different content types (only for non-FormData)
      if ((response.data == null || (response.data is String && response.data.isEmpty)) &&
          (response.statusCode == 200 || response.statusCode == 201) &&
          data is! FormData) {

        print('⚠️ Empty response detected, trying with different content type');

        // Try with form URL encoded content type
        response = await _dio.post(
          path,
          data: data,
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {'Accept': 'application/json'},
          ),
        );
      }

      print('📥 RESPONSE STATUS: ${response.statusCode}');
      print('📥 RESPONSE HEADERS:');
      response.headers.forEach((name, values) {
        print('   $name: $values');
      });
      print('📥 RESPONSE RAW DATA: ${response.data}');
      print('📥 RESPONSE DATA TYPE: ${response.data.runtimeType}');

      // If response is a string, try to parse it as JSON
      if (response.data is String && response.data.isNotEmpty) {
        try {
          final jsonData = json.decode(response.data);
          print('📥 PARSED JSON: $jsonData');

          // Create a new response with the parsed data
          return Response(
            data: jsonData,
            headers: response.headers,
            requestOptions: response.requestOptions,
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            redirects: response.redirects,
            extra: response.extra,
          );
        } catch (e) {
          print('❌ FAILED TO PARSE JSON: $e');
        }
      }

      return response;
    } on DioException catch (e) {
      print('❌ DIO EXCEPTION: ${e.type}');
      print('❌ ERROR MESSAGE: ${e.message}');
      print('❌ REQUEST DATA: ${e.requestOptions.data}');
      print('❌ RESPONSE DATA: ${e.response?.data}');
      throw _handleError(e);
    } catch (e) {
      print('❌ UNEXPECTED ERROR: $e');
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data, Options? options}) async {
    try {
      return await _dio.put(
        path,
        data: data,
        options: options ?? Options(contentType: Headers.jsonContentType),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path, {dynamic data, Options? options}) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        options: options ?? Options(contentType: Headers.jsonContentType),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // NEW METHOD: For uploading files with progress tracking
  Future<Response> uploadFile(
      String path, {
        required FormData data,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      print('📤 UPLOADING FILE TO: ${_dio.options.baseUrl}$path');

      final token = storage.read('token');
      final headers = <String, dynamic>{
        'Accept': 'application/json',
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.post(
        path,
        data: data,
        options: Options(
          headers: headers,
          contentType: 'multipart/form-data',
        ),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      print('📥 UPLOAD RESPONSE STATUS: ${response.statusCode}');
      print('📥 UPLOAD RESPONSE DATA: ${response.data}');

      return response;
    } on DioException catch (e) {
      print('❌ UPLOAD ERROR: ${e.type}');
      print('❌ UPLOAD ERROR MESSAGE: ${e.message}');
      print('❌ UPLOAD ERROR RESPONSE: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // NEW METHOD: Set auth token manually
  void setAuthToken(String token) {
    storage.write('token', token);
  }

  // NEW METHOD: Clear auth token
  void clearAuthToken() {
    storage.remove('token');
    storage.remove('refreshToken');
  }

  // NEW METHOD: Check if user is authenticated
  bool get isAuthenticated => storage.read('token') != null;

  String _handleError(DioException error) {
    String errorMessage = 'حدث خطأ ما. يرجى المحاولة مرة أخرى لاحقًا.';

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      errorMessage = 'انتهت مهلة الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';
    } else if (error.type == DioExceptionType.badResponse) {
      if (error.response?.data != null) {
        // Handle different error response formats
        if (error.response!.data is Map && error.response!.data['message'] != null) {
          errorMessage = error.response!.data['message'];
        } else if (error.response!.data is String && error.response!.data.isNotEmpty) {
          try {
            final jsonData = json.decode(error.response!.data);
            if (jsonData is Map && jsonData['message'] != null) {
              errorMessage = jsonData['message'];
            }
          } catch (_) {
            // Not JSON, just use the string as is if meaningful
            if (error.response!.data.toString().length < 100) {
              errorMessage = error.response!.data.toString();
            }
          }
        }
      } else {
        switch (error.response?.statusCode) {
          case 400:
            errorMessage = 'طلب غير صالح.';
            break;
          case 401:
            errorMessage = 'غير مصرح لك بالوصول.';
            break;
          case 403:
            errorMessage = 'ليس لديك إذن للوصول إلى هذا المورد.';
            break;
          case 404:
            errorMessage = 'المورد المطلوب غير موجود.';
            break;
          case 500:
            errorMessage = 'خطأ في الخادم.';
            break;
        }
      }
    } else if (error.type == DioExceptionType.cancel) {
      errorMessage = 'تم إلغاء الطلب.';
    } else if (error.type == DioExceptionType.connectionError) {
      errorMessage = 'فشل الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت.';
    }

    return errorMessage;
  }
}