import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as g;
import 'package:real_estate_app/app/data/providers/api_provider.dart';

class ImageUploadService {
  final ApiProvider _apiProvider = g.Get.find<ApiProvider>();

  /// Upload a single image file and return the URL
  Future<String> uploadSingleImage(File imageFile) async {
    try {
      // Read the image file as bytes
      final bytes = await imageFile.readAsBytes();

      // Convert to base64
      final base64Image = base64Encode(bytes);

      // Get file extension
      final extension = imageFile.path.split('.').last.toLowerCase();

      // Create upload request
      final uploadData = {
        'fileName': 'property_image_${DateTime.now().millisecondsSinceEpoch}.$extension',
        'fileData': base64Image,
        'contentType': _getContentType(extension),
      };

      // Upload to your backend using the updated post method
      final response = await _apiProvider.post(
        '/api/images/upload-file',
        data: uploadData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle different response formats
        if (response.data is Map && response.data['imageUrl'] != null) {
          return response.data['imageUrl'];
        } else if (response.data is String) {
          // Try to parse string response
          try {
            final jsonData = json.decode(response.data);
            if (jsonData['imageUrl'] != null) {
              return jsonData['imageUrl'];
            }
          } catch (_) {
            // If it's not JSON, assume the string itself is the URL
            return response.data;
          }
        }
        throw 'لم يتم العثور على رابط الصورة في الاستجابة';
      } else {
        throw 'فشل في رفع الصورة - رمز الحالة: ${response.statusCode}';
      }
    } catch (e) {
      throw 'فشل في رفع الصورة: ${e.toString()}';
    }
  }

  /// Upload multiple images and return their URLs
  Future<List<String>> uploadMultipleImages(List<File> imageFiles) async {
    final List<String> uploadedUrls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      try {
        final url = await uploadSingleImage(imageFiles[i]);
        uploadedUrls.add(url);
      } catch (e) {
        print('Failed to upload image ${i + 1}: $e');
        // You can choose to continue with other images or throw an error
        throw 'فشل في رفع الصورة رقم ${i + 1}: ${e.toString()}';
      }
    }

    return uploadedUrls;
  }

  /// Alternative method using FormData (if your backend supports multipart uploads)
  Future<String> uploadImageWithFormData(File imageFile) async {
    try {
      final fileName = 'property_image_${DateTime.now().millisecondsSinceEpoch}.${imageFile.path.split('.').last}';

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      // Use the new uploadFile method from ApiProvider
      final response = await _apiProvider.uploadFile(
        '/api/images/upload-multipart',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle different response formats
        if (response.data is Map && response.data['imageUrl'] != null) {
          return response.data['imageUrl'];
        } else if (response.data is String) {
          try {
            final jsonData = json.decode(response.data);
            if (jsonData['imageUrl'] != null) {
              return jsonData['imageUrl'];
            }
          } catch (_) {
            return response.data;
          }
        }
        throw 'لم يتم العثور على رابط الصورة في الاستجابة';
      } else {
        throw 'فشل في رفع الصورة - رمز الحالة: ${response.statusCode}';
      }
    } catch (e) {
      throw 'فشل في رفع الصورة: ${e.toString()}';
    }
  }

  /// Upload with progress callback
  Future<String> uploadImageWithProgress(
      File imageFile, {
        void Function(double progress)? onProgress,
      }) async {
    try {
      final fileName = 'property_image_${DateTime.now().millisecondsSinceEpoch}.${imageFile.path.split('.').last}';

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _apiProvider.uploadFile(
        '/api/images/upload-multipart',
        data: formData,
        onSendProgress: (sent, total) {
          if (onProgress != null && total > 0) {
            onProgress(sent / total);
          }
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map && response.data['imageUrl'] != null) {
          return response.data['imageUrl'];
        } else if (response.data is String) {
          try {
            final jsonData = json.decode(response.data);
            if (jsonData['imageUrl'] != null) {
              return jsonData['imageUrl'];
            }
          } catch (_) {
            return response.data;
          }
        }
        throw 'لم يتم العثور على رابط الصورة في الاستجابة';
      } else {
        throw 'فشل في رفع الصورة - رمز الحالة: ${response.statusCode}';
      }
    } catch (e) {
      throw 'فشل في رفع الصورة: ${e.toString()}';
    }
  }

  /// Upload multiple images with overall progress
  Future<List<String>> uploadMultipleImagesWithProgress(
      List<File> imageFiles, {
        void Function(double progress, int currentIndex, int total)? onProgress,
      }) async {
    final List<String> uploadedUrls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      try {
        final url = await uploadImageWithProgress(
          imageFiles[i],
          onProgress: (fileProgress) {
            if (onProgress != null) {
              final overallProgress = (i + fileProgress) / imageFiles.length;
              onProgress(overallProgress, i + 1, imageFiles.length);
            }
          },
        );
        uploadedUrls.add(url);
      } catch (e) {
        print('Failed to upload image ${i + 1}: $e');
        throw 'فشل في رفع الصورة رقم ${i + 1}: ${e.toString()}';
      }
    }

    return uploadedUrls;
  }

  /// Get content type based on file extension
  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  /// Compress image before upload (optional)
  Future<Uint8List> compressImage(File imageFile, {int quality = 85}) async {
    // You can use packages like flutter_image_compress for this
    // For now, just return the original bytes
    return await imageFile.readAsBytes();
  }

  /// Validate image file
  bool isValidImageFile(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
  }

  /// Get file size in MB
  Future<double> getFileSizeInMB(File file) async {
    final bytes = await file.length();
    return bytes / (1024 * 1024);
  }

  /// Validate file size (max 5MB by default)
  Future<bool> isValidFileSize(File file, {double maxSizeMB = 5.0}) async {
    final sizeInMB = await getFileSizeInMB(file);
    return sizeInMB <= maxSizeMB;
  }
}