import 'package:real_estate_app/app/data/models/property_model.dart';

class BookingModel {
  final String id;
  final String propertyId;
  final String userId;
  final int status;
  final DateTime requestDate;
  final DateTime? visitDateTime;
  final String message;
  final String contactPhone;
  final DateTime createdAt;
  final BookingProperty? property;

  BookingModel({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.status,
    required this.requestDate,
    this.visitDateTime,
    required this.message,
    required this.contactPhone,
    required this.createdAt,
    this.property,
  });

  String get statusText {
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

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      propertyId: json['propertyId'],
      userId: json['userId'] ?? '',
      status: json['status'] is int ? json['status'] : int.parse(json['status'].toString()),
      requestDate: DateTime.parse(json['requestDate']),
      visitDateTime: json['visitDateTime'] != null ? DateTime.parse(json['visitDateTime']) : null,
      message: json['message'],
      contactPhone: json['contactPhone'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      property: json['property'] != null
          ? BookingProperty.fromJson(json['property'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['propertyId'] = propertyId;
    data['userId'] = userId;
    data['status'] = status;
    data['requestDate'] = requestDate.toIso8601String();
    if (visitDateTime != null) data['visitDateTime'] = visitDateTime!.toIso8601String();
    data['message'] = message;
    data['contactPhone'] = contactPhone;
    data['createdAt'] = createdAt.toIso8601String();
    if (property != null) {
      data['property'] = property!.toJson();
    }
    return data;
  }
}

class BookingProperty {
  final String title;
  final String mainImageUrl;
  final String location;
  final int price;

  BookingProperty({
    required this.title,
    required this.mainImageUrl,
    required this.location,
    required this.price,
  });

  factory BookingProperty.fromJson(Map<String, dynamic> json) {
    return BookingProperty(
      title: json['title'],
      mainImageUrl: json['mainImageUrl'],
      location: json['location'],
      price: json['price'] is int
          ? json['price']
          : (json['price'] is double
          ? json['price'].toInt()
          : int.parse(json['price'].toString())),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['mainImageUrl'] = mainImageUrl;
    data['location'] = location;
    data['price'] = price;
    return data;
  }
}

class BookingListResponse {
  final int totalCount;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final List<BookingModel> bookings;

  BookingListResponse({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.bookings,
  });

  factory BookingListResponse.fromJson(Map<String, dynamic> json) {
    return BookingListResponse(
      totalCount: json['totalCount'] is String ? int.parse(json['totalCount']) : json['totalCount'],
      totalPages: json['totalPages'] is String ? int.parse(json['totalPages']) : json['totalPages'],
      currentPage: json['currentPage'] is String ? int.parse(json['currentPage']) : json['currentPage'],
      pageSize: json['pageSize'] is String ? int.parse(json['pageSize']) : json['pageSize'],
      bookings: json.containsKey('items')
          ? (json['items'] as List).map((e) => BookingModel.fromJson(e)).toList()
          : [],
    );
  }
}

class CreateBookingRequest {
  final String propertyId;
  final DateTime requestDate;
  final DateTime visitDateTime;
  final String message;
  final String contactPhone;

  CreateBookingRequest({
    required this.propertyId,
    required this.requestDate,
    required this.visitDateTime,
    required this.message,
    required this.contactPhone,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['propertyId'] = propertyId;
    data['requestDate'] = requestDate.toUtc().toIso8601String();
    data['visitDateTime'] = visitDateTime.toUtc().toIso8601String();
    data['message'] = message;
    data['contactPhone'] = contactPhone;
    return data;
  }
}

class UpdateBookingStatusRequest {
  final int status;

  UpdateBookingStatusRequest({
    required this.status,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    return data;
  }
}
