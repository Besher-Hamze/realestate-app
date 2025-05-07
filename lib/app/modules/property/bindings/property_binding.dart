import 'package:get/get.dart';
import 'package:real_estate_app/app/data/providers/api_provider.dart';
import 'package:real_estate_app/app/data/repositories/favorite_repository.dart';
import 'package:real_estate_app/app/data/repositories/property_repository.dart';
import 'package:real_estate_app/app/modules/property/controllers/property_controller.dart';

import '../../../data/repositories/booking_repository.dart';

class PropertyBinding extends Bindings {
  @override
  void dependencies() {
    // API Provider
    Get.lazyPut<ApiProvider>(() => ApiProvider(), fenix: true);

    // Repositories
    Get.lazyPut<PropertyRepository>(() => PropertyRepository(), fenix: true);
    Get.lazyPut<FavoriteRepository>(() => FavoriteRepository(), fenix: true);

    // Controllers
    Get.lazyPut<PropertyController>(() => PropertyController(), fenix: true);
    Get.lazyPut<BookingRepository>(()=>BookingRepository(),fenix: true);
  }
}