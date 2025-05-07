import 'package:get/get.dart';
import 'package:real_estate_app/app/data/providers/api_provider.dart';
import 'package:real_estate_app/app/data/repositories/property_repository.dart';
import 'package:real_estate_app/app/data/repositories/user_repository.dart';
import 'package:real_estate_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/app/modules/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // API Provider
    Get.lazyPut<ApiProvider>(() => ApiProvider(), fenix: true);

    // Repositories
    Get.lazyPut<PropertyRepository>(() => PropertyRepository(), fenix: true);
    Get.lazyPut<UserRepository>(() => UserRepository(), fenix: true);

    // Controllers
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}