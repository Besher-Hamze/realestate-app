import 'package:get/get.dart';
import 'package:real_estate_app/app/modules/auth/bindings/auth_binding.dart';
import 'package:real_estate_app/app/modules/auth/views/login_view.dart';
import 'package:real_estate_app/app/modules/auth/views/register_view.dart';
import 'package:real_estate_app/app/modules/booking/bindings/booking_binding.dart';
import 'package:real_estate_app/app/modules/booking/views/booking_list_view.dart';
import 'package:real_estate_app/app/modules/favorites/bindings/favorites_binding.dart';
import 'package:real_estate_app/app/modules/favorites/views/favorites_view.dart';
import 'package:real_estate_app/app/modules/home/bindings/home_binding.dart';
import 'package:real_estate_app/app/modules/home/views/home_view.dart';
import 'package:real_estate_app/app/modules/profile/bindings/profile_binding.dart';
import 'package:real_estate_app/app/modules/profile/views/change_password_view.dart';
import 'package:real_estate_app/app/modules/profile/views/profile_view.dart';
import 'package:real_estate_app/app/modules/property/bindings/property_binding.dart';
import 'package:real_estate_app/app/modules/property/views/property_detail_view.dart';
import 'package:real_estate_app/app/modules/property/views/property_list_view.dart';
import 'package:real_estate_app/app/modules/property/views/property_search_view.dart';


class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.PROPERTY_LIST,
      page: () => const PropertyListView(),
      binding: PropertyBinding(),
    ),
    GetPage(
      name: Routes.PROPERTY_DETAIL,
      page: () => const PropertyDetailView(),
      binding: PropertyBinding(),
    ),
    GetPage(
      name: Routes.PROPERTY_SEARCH,
      page: () => const PropertySearchView(),
      binding: PropertyBinding(),
    ),
    GetPage(
      name: Routes.BOOKING_LIST,
      page: () => const BookingListView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.FAVORITES,
      page: () => const FavoritesView(),
      binding: FavoritesBinding(),
    ),
  ];
}

abstract class Routes {
  static const HOME = '/';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const PROPERTY_LIST = '/properties';
  static const PROPERTY_DETAIL = '/properties/:id';
  static const PROPERTY_SEARCH = '/search';
  static const BOOKING_LIST = '/bookings';
  static const PROFILE = '/profile';
  static const CHANGE_PASSWORD = '/change-password';
  static const FAVORITES = '/favorites';
}


