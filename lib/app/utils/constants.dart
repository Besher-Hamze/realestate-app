class Constants {
  // API
  static const String baseUrl = 'http://192.168.74.10:5267'; // Replace with actual API URL

  // Storage Keys
  static const String tokenKey = 'token';
  static const String refreshTokenKey = 'refreshToken';
  static const String userIdKey = 'userId';
  static const String usernameKey = 'username';
  static const String userProfileKey = 'userProfile';

  // Property Types
  static const List<String> propertyTypes = ['apartment', 'villa', 'land'];

  // Booking Status
  static const List<String> bookingStatus = ['pending', 'approved', 'rejected', 'completed'];

  // Sort Options
  static const Map<String, String> sortOptions = {
    'price_asc': 'السعر (الأقل أولاً)',
    'price_desc': 'السعر (الأعلى أولاً)',
    'date_desc': 'الأحدث أولاً',
    'date_asc': 'الأقدم أولاً',
    'area_asc': 'المساحة (الأقل أولاً)',
    'area_desc': 'المساحة (الأكبر أولاً)',
  };

  // Property Features
  static const List<String> propertyFeatures = [
    'مطبخ مجهز',
    'تكييف مركزي',
    'موقف سيارات',
    'أمن 24 ساعة',
    'قريب من المراكز التجارية',
    'حديقة',
    'مسبح',
    'مصعد',
    'انترنت',
    'غرفة غسيل'
  ];

  // Locations (Cities)
  static const List<String> cities = [
    'الرياض',
    'جدة',
    'مكة',
    'المدينة',
    'الدمام',
    'الخبر',
    'تبوك',
    'أبها',
    'حائل',
    'نجران'
  ];

  // Price Ranges
  static const List<Map<String, dynamic>> priceRanges = [
    {'min': 0, 'max': 100000, 'label': 'أقل من 100,000'},
    {'min': 100000, 'max': 300000, 'label': '100,000 - 300,000'},
    {'min': 300000, 'max': 500000, 'label': '300,000 - 500,000'},
    {'min': 500000, 'max': 750000, 'label': '500,000 - 750,000'},
    {'min': 750000, 'max': 1000000, 'label': '750,000 - 1,000,000'},
    {'min': 1000000, 'max': 2000000, 'label': '1,000,000 - 2,000,000'},
    {'min': 2000000, 'max': -1, 'label': 'أكثر من 2,000,000'},
  ];

  // Area Ranges
  static const List<Map<String, dynamic>> areaRanges = [
    {'min': 0, 'max': 100, 'label': 'أقل من 100 م²'},
    {'min': 100, 'max': 200, 'label': '100 - 200 م²'},
    {'min': 200, 'max': 300, 'label': '200 - 300 م²'},
    {'min': 300, 'max': 500, 'label': '300 - 500 م²'},
    {'min': 500, 'max': 750, 'label': '500 - 750 م²'},
    {'min': 750, 'max': 1000, 'label': '750 - 1000 م²'},
    {'min': 1000, 'max': -1, 'label': 'أكثر من 1000 م²'},
  ];

  // Bedrooms Options
  static const List<int> bedroomsOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // Bathrooms Options
  static const List<int> bathroomsOptions = [1, 2, 3, 4, 5, 6, 7, 8];
}