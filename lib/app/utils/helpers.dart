import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpers {
  // Format currency
  static String formatCurrency(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'ar_SA',
      symbol: 'ر.س ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Format date
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(date);
  }

  // Format time
  static String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  // Format date and time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
  }

  // Format relative time (e.g., "2 days ago")
  static String formatRelativeTime(DateTime dateTime) {
    return Jiffy.now().fromNow();
  }

  // Format area in square meters
  static String formatArea(num area) {
    return '$area م²';
  }

  // Format property type
  static String formatPropertyType(dynamic propertyType) {
    if (propertyType is int) {
      switch (propertyType) {
        case 1:
          return 'شقة';
        case 2:
          return 'فيلا';
        case 3:
          return 'أرض';
        case 4:
          return 'مكتب';
        case 5:
          return 'محل تجاري';
        default:
          return 'غير محدد';
      }
    }
    
    // Legacy string support
    if (propertyType is String) {
      switch (propertyType) {
        case 'apartment':
          return 'شقة';
        case 'villa':
          return 'فيلا';
        case 'land':
          return 'أرض';
        default:
          return propertyType;
      }
    }
    
    return 'غير محدد';
  }

  // Format booking status
  static String formatBookingStatus(dynamic status) {
    if (status is int) {
      switch (status) {
        case 0:
          return 'في الانتظار';
        case 1:
          return 'موافق عليه';
        case 2:
          return 'مرفوض';
        case 3:
          return 'ملغي';
        case 4:
          return 'مكتمل';
        default:
          return 'غير معروف';
      }
    }
    
    // Legacy string support
    if (status is String) {
      switch (status) {
        case 'pending':
          return 'في الانتظار';
        case 'approved':
          return 'موافق عليه';
        case 'rejected':
          return 'مرفوض';
        case 'completed':
          return 'مكتمل';
        default:
          return status;
      }
    }
    
    return 'غير معروف';
  }

  // Get booking status color
  static Color getBookingStatusColor(dynamic status) {
    if (status is int) {
      switch (status) {
        case 0:
          return Colors.orange;
        case 1:
          return Colors.green;
        case 2:
          return Colors.red;
        case 3:
          return Colors.grey;
        case 4:
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }
    
    // Legacy string support
    if (status is String) {
      switch (status) {
        case 'pending':
          return Colors.orange;
        case 'approved':
          return Colors.green;
        case 'rejected':
          return Colors.red;
        case 'completed':
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }
    
    return Colors.grey;
  }

  // Show success snackbar
  static void showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  // Show error snackbar
  static void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  // Show info snackbar
  static void showInfoSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  // Show loading indicator
  static void showLoading({String message = 'جاري التحميل...'}) {
    EasyLoading.show(status: message);
  }

  // Hide loading indicator
  static void hideLoading() {
    EasyLoading.dismiss();
  }

  // Make a phone call
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  // Send email
  static Future<void> sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }

  // Open map with coordinates
  static Future<void> openMap(double latitude, double longitude) async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
  }
}