class Constants {
  // API
  static const String baseUrl = 'http://192.168.74.4:5268'; // Keep as is unless your server changes

  // Storage Keys
  static const String tokenKey = 'token';
  static const String refreshTokenKey = 'refreshToken';
  static const String userIdKey = 'userId';
  static const String userProfileKey = 'userProfile';

  // Property Types (integers to match API)
  static const Map<int, String> propertyTypes = {
    1: 'شقة',
    2: 'فيلا',
    3: 'أرض',
    4: 'مكتب',
    5: 'محل تجاري',
  };

  // Booking Status (integers to match API)
  static const Map<int, String> bookingStatus = {
    0: 'في الانتظار',
    1: 'موافق عليه',
    2: 'مرفوض',
    3: 'ملغي',
    4: 'مكتمل',
  };

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
    'غرفة غسيل',
  ];

  // Locations (Cities in Syria)
  static const List<String> cities = [
    'دمشق',
    'حلب',
    'حمص',
    'اللاذقية',
    'طرطوس',
    'حماة',
    'دير الزور',
    'الرقة',
    'إدلب',
    'السويداء',
  ];

  // Price Ranges (in Syrian Pound, SYP)
  static const List<Map<String, dynamic>> priceRanges = [
    {'min': 0, 'max': 50000000, 'label': 'أقل من 50,000,000 ل.س'},
    {'min': 50000000, 'max': 100000000, 'label': '50,000,000 - 100,000,000 ل.س'},
    {'min': 100000000, 'max': 200000000, 'label': '100,000,000 - 200,000,000 ل.س'},
    {'min': 200000000, 'max': 300000000, 'label': '200,000,000 - 300,000,000 ل.س'},
    {'min': 300000000, 'max': 500000000, 'label': '300,000,000 - 500,000,000 ل.س'},
    {'min': 500000000, 'max': 1000000000, 'label': '500,000,000 - 1,000,000,000 ل.س'},
    {'min': 1000000000, 'max': -1, 'label': 'أكثر من 1,000,000,000 ل.س'},
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