import 'package:get/get.dart';
import 'package:real_estate_app/app/data/providers/api_provider.dart';
import 'package:real_estate_app/app/data/repositories/auth_repository.dart';
import 'package:real_estate_app/app/data/repositories/user_repository.dart';
import 'package:real_estate_app/app/modules/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // API Provider
    Get.lazyPut<ApiProvider>(() => ApiProvider(), fenix: true);

    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    Get.lazyPut<UserRepository>(() => UserRepository(), fenix: true);

    // Controllers
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}