
class FavoriteModel {
  final String id;
  final String propertyId;
  final FavoriteProperty property;
  final DateTime addedAt;

  FavoriteModel({
    required this.id,
    required this.propertyId,
    required this.property,
    required this.addedAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      propertyId: json['propertyId'],
      property: FavoriteProperty.fromJson(json['property']),
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['propertyId'] = propertyId;
    data['property'] = property.toJson();
    data['addedAt'] = addedAt.toIso8601String();
    return data;
  }
}

class FavoriteProperty {
  final String title;
  final int price;
  final String location;
  final int bedrooms;
  final double area;
  final String mainImageUrl;
  final bool isAvailable;

  FavoriteProperty({
    required this.title,
    required this.price,
    required this.location,
    required this.bedrooms,
    required this.area,
    required this.mainImageUrl,
    required this.isAvailable,
  });

  factory FavoriteProperty.fromJson(Map<String, dynamic> json) {
    return FavoriteProperty(
      title: json['title'],
      // Handle int, double, and String types for price
      price: json['price'] is int
          ? json['price']
          : (json['price'] is double
          ? json['price'].toInt()
          : int.parse(json['price'].toString())),
      location: json['location'],
      // Handle int, double, and String types for bedrooms
      bedrooms: json['bedrooms'] is int
          ? json['bedrooms']
          : (json['bedrooms'] is double
          ? json['bedrooms'].toInt()
          : int.parse(json['bedrooms'].toString())),
      // Handle multiple types for area
      area: json['area'] is double
          ? json['area']
          : (json['area'] is int
          ? (json['area'] as int).toDouble()
          : double.parse(json['area'].toString())),
      mainImageUrl: json['mainImageUrl'],
      isAvailable: json['isAvailable'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['price'] = price;
    data['location'] = location;
    data['bedrooms'] = bedrooms;
    data['area'] = area;
    data['mainImageUrl'] = mainImageUrl;
    data['isAvailable'] = isAvailable;
    return data;
  }
}
class FavoriteListResponse {
  final int totalCount;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final List<FavoriteModel> favorites;

  FavoriteListResponse({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.favorites,
  });

  factory FavoriteListResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteListResponse(
      totalCount: json['totalCount'] is int
          ? json['totalCount']
          : int.parse(json['totalCount'].toString()),
      totalPages: json['totalPages'] is int
          ? json['totalPages']
          : int.parse(json['totalPages'].toString()),
      currentPage: json['currentPage'] is int
          ? json['currentPage']
          : int.parse(json['currentPage'].toString()),
      pageSize: json['pageSize'] is int
          ? json['pageSize']
          : int.parse(json['pageSize'].toString()),
      // Handle null or missing favorites key
      favorites: json['favorites'] != null
          ? (json['favorites'] as List).map((e) => FavoriteModel.fromJson(e)).toList()
          : json['items'] != null  // Check if the data is under 'items' key instead
          ? (json['items'] as List).map((e) => FavoriteModel.fromJson(e)).toList()
          : [],  // Return empty list if favorites or items are null
    );
  }
}