import 'package:get/get.dart';
import 'package:real_estate_app/app/data/providers/api_provider.dart';
import 'package:real_estate_app/app/data/repositories/favorite_repository.dart';
import 'package:real_estate_app/app/modules/favorites/controllers/favorites_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    // API Provider
    Get.lazyPut<ApiProvider>(() => ApiProvider(), fenix: true);

    // Repositories
    Get.lazyPut<FavoriteRepository>(() => FavoriteRepository(), fenix: true);

    // Controllers
    Get.lazyPut<FavoritesController>(() => FavoritesController(), fenix: true);
  }
}