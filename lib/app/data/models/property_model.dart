class PropertyModel {
  final String id;
  final String title;
  final String description;
  final int price;
  final double area;
  final int bedrooms;
  final int bathrooms;
  final String propertyType;
  final String location;
  final String? address;
  final double latitude;
  final double longitude;
  final String mainImageUrl;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<PropertyFeature>? features;
  final List<PropertyImage>? images;
  final PropertyOwner? owner;

  PropertyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    required this.propertyType,
    required this.location,
    this.address,
    required this.latitude,
    required this.longitude,
    required this.mainImageUrl,
    required this.isAvailable,
    required this.createdAt,
    this.updatedAt,
    this.features,
    this.images,
    this.owner,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return PropertyModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      // Handle int, double, and String types for price
      price: json['price'] is int
          ? json['price']
          : (json['price'] is double
          ? json['price'].toInt()
          : int.parse(json['price'].toString())),
      // Handle multiple types for area
      area: json['area'] is double
          ? json['area']
          : (json['area'] is int
          ? (json['area'] as int).toDouble()
          : double.parse(json['area'].toString())),
      // Handle int, double, and String types for bedrooms
      bedrooms: json['bedrooms'] is int
          ? json['bedrooms']
          : (json['bedrooms'] is double
          ? json['bedrooms'].toInt()
          : int.parse(json['bedrooms'].toString())),
      // Handle int, double, and String types for bathrooms
      bathrooms: json['bathrooms'] is int
          ? json['bathrooms']
          : (json['bathrooms'] is double
          ? json['bathrooms'].toInt()
          : int.parse(json['bathrooms'].toString())),
      // Convert propertyType to String
      propertyType: json['propertyType'].toString(),
      location: json['location'],
      address: json['address'],
      // Handle multiple types for latitude
      latitude: json['latitude'] is double
          ? json['latitude']
          : (json['latitude'] is int
          ? (json['latitude'] as int).toDouble()
          : double.parse(json['latitude'].toString())),
      // Handle multiple types for longitude
      longitude: json['longitude'] is double
          ? json['longitude']
          : (json['longitude'] is int
          ? (json['longitude'] as int).toDouble()
          : double.parse(json['longitude'].toString())),
      mainImageUrl: json['mainImageUrl'],
      isAvailable: json['isAvailable'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      features: json['features'] != null
          ? (json['features'] as List).map((e) => e.toString()).map((e) => PropertyFeature(name: e)).toList()
          : null,
      images: json['images'] != null
          ? (json['images'] as List).map((e) => PropertyImage.fromJson(e)).toList()
          : null,
      owner: json['owner'] != null ? PropertyOwner.fromJson(json['owner']) : null,
    );
  }
  factory PropertyModel.fromListJson(Map<String, dynamic> json) {
    print(json);
    print("==============================================================");
    return PropertyModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      // Handle both int, double, and String types for price
      price: json['price'] is int
          ? json['price']
          : (json['price'] is double
          ? json['price'].toInt()
          : int.parse(json['price'].toString())),
      area: json['area'] is double
          ? json['area']
          : (json['area'] is int
          ? (json['area'] as int).toDouble()
          : double.parse(json['area'].toString())),
      bedrooms: json['bedrooms'] is int ? json['bedrooms'] : int.parse(json['bedrooms'].toString()),
      bathrooms: json['bathrooms'] is int ? json['bathrooms'] : int.parse(json['bathrooms'].toString()),
      propertyType: json['propertyType'].toString(),
      location: json['location'],
      latitude: json['latitude'] == null
          ? 0.0
          : (json['latitude'] is double
          ? json['latitude']
          : (json['latitude'] is int
          ? (json['latitude'] as int).toDouble()
          : double.parse(json['latitude'].toString()))),
      longitude: json['longitude'] == null
          ? 0.0
          : (json['longitude'] is double
          ? json['longitude']
          : (json['longitude'] is int
          ? (json['longitude'] as int).toDouble()
          : double.parse(json['longitude'].toString()))),
      mainImageUrl: json['mainImageUrl'],
      isAvailable: json['isAvailable'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: null,
    );
  }  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['area'] = area;
    data['bedrooms'] = bedrooms;
    data['bathrooms'] = bathrooms;
    data['propertyType'] = propertyType;
    data['location'] = location;
    if (address != null) data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['mainImageUrl'] = mainImageUrl;
    data['isAvailable'] = isAvailable;
    data['createdAt'] = createdAt.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();
    if (features != null) {
      data['features'] = features!.map((e) => e.name).toList();
    }
    if (images != null) {
      data['images'] = images!.map((e) => e.toJson()).toList();
    }
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    return data;
  }
}

class PropertyImage {
  final String id;
  final String url;
  final String? description;

  PropertyImage({
    required this.id,
    required this.url,
    this.description,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      id: json['id'],
      url: json['url'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    if (description != null) data['description'] = description;
    return data;
  }
}

class PropertyFeature {
  final String name;

  PropertyFeature({
    required this.name,
  });
}

class PropertyOwner {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;

  PropertyOwner({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
  });

  factory PropertyOwner.fromJson(Map<String, dynamic> json) {
    return PropertyOwner(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    return data;
  }
}

class PropertyListResponse {
  final int totalCount;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final List<PropertyModel> properties;

  PropertyListResponse({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.properties,
  });

  factory PropertyListResponse.fromJson(Map<String, dynamic> json) {
    return PropertyListResponse(
      totalCount: int.parse(json['totalCount'].toString()),
      totalPages: int.parse(json['totalPages'].toString()),
      currentPage: int.parse(json['currentPage'].toString()),
      pageSize: int.parse(json['pageSize'].toString()),
      properties: (json['items'] as List)
          .map((e) => PropertyModel.fromListJson(e))
          .toList(),
    );
  }
}

class PropertyFilter {
  int? page;
  int? pageSize;
  String? sortBy;
  String? sortDirection;
  int? minPrice;
  int? maxPrice;
  String? propertyType;
  int? bedrooms;
  String? location;

  PropertyFilter({
    this.page = 1,
    this.pageSize = 10,
    this.sortBy,
    this.sortDirection,
    this.minPrice,
    this.maxPrice,
    this.propertyType,
    this.bedrooms,
    this.location,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (page != null) data['page'] = page;
    if (pageSize != null) data['pageSize'] = pageSize;
    if (sortBy != null) data['sortBy'] = sortBy;
    if (sortDirection != null) data['sortDirection'] = sortDirection;
    if (minPrice != null) data['minPrice'] = minPrice;
    if (maxPrice != null) data['maxPrice'] = maxPrice;
    if (propertyType != null) data['propertyType'] = propertyType;
    if (bedrooms != null) data['bedrooms'] = bedrooms;
    if (location != null) data['location'] = location;
    return data;
  }

  PropertyFilter copyWith({
    int? page,
    int? pageSize,
    String? sortBy,
    String? sortDirection,
    int? minPrice,
    int? maxPrice,
    String? propertyType,
    int? bedrooms,
    String? location,
  }) {
    return PropertyFilter(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      propertyType: propertyType ?? this.propertyType,
      bedrooms: bedrooms ?? this.bedrooms,
      location: location ?? this.location,
    );
  }
}