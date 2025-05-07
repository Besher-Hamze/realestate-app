import 'package:get/get.dart';
import 'package:real_estate_app/app/data/providers/api_provider.dart';
import 'package:real_estate_app/app/data/repositories/booking_repository.dart';
import 'package:real_estate_app/app/modules/booking/controllers/booking_controller.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    // API Provider
    Get.lazyPut<ApiProvider>(() => ApiProvider(), fenix: true);

    // Repositories
    Get.lazyPut<BookingRepository>(() => BookingRepository(), fenix: true);

    // Controllers
    Get.lazyPut<BookingController>(() => BookingController(), fenix: true);
  }
}