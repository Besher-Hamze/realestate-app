import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/app/data/models/auth_model.dart';
import 'package:real_estate_app/app/data/models/user_model.dart';
import 'package:real_estate_app/app/data/repositories/auth_repository.dart';
import 'package:real_estate_app/app/data/repositories/user_repository.dart';
import 'package:real_estate_app/app/routes/app_pages.dart';
import 'package:real_estate_app/app/utils/helpers.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final UserRepository _userRepository = Get.find<UserRepository>();

  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // State variables
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final user = Rxn<UserModel>();

  // Error messages
  final loginErrorMessage = ''.obs;
  final registerErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // Check if user is already logged in
  void checkLoginStatus() {
    if (_authRepository.isLoggedIn()) {
      // Fetch user profile if logged in
      getUserProfile();
    }
  }

  // Get user profile
  Future<void> getUserProfile() async {
    try {
      // Try to get from cache first
      final cachedProfile = _userRepository.getCachedProfile();
      if (cachedProfile != null) {
        user.value = cachedProfile;
      }

      // Fetch latest profile data
      final profile = await _userRepository.getUserProfile();
      user.value = profile;
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  // Login function
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      loginErrorMessage.value = '';

      final request = LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final response = await _authRepository.login(request);

      // Clear form fields
      emailController.clear();
      passwordController.clear();

      // Get user profile
      await getUserProfile();

      // Navigate to home
      Get.offAllNamed(Routes.HOME);

      Helpers.showSuccessSnackbar(
        'تم تسجيل الدخول',
        'مرحبًا ${response.username}',
      );
    } catch (e) {
      loginErrorMessage.value = e.toString();
      Helpers.showErrorSnackbar('فشل تسجيل الدخول', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Register function
  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      registerErrorMessage.value = 'كلمة المرور غير متطابقة';
      Helpers.showErrorSnackbar('خطأ', 'كلمة المرور غير متطابقة');
      return;
    }

    try {
      isLoading.value = true;
      registerErrorMessage.value = '';

      final request = RegisterRequest(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phoneNumber: phoneController.text.trim(),
        fullName: fullNameController.text.trim(),
      );

      final response = await _authRepository.register(request);

      // Clear form fields
      usernameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      phoneController.clear();
      fullNameController.clear();

      // Navigate to login page
      Get.offNamed(Routes.LOGIN);

      Helpers.showSuccessSnackbar(
        'تم التسجيل بنجاح',
        'يمكنك الآن تسجيل الدخول',
      );
    } catch (e) {
      registerErrorMessage.value = e.toString();
      Helpers.showErrorSnackbar('فشل التسجيل', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Logout function
  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _authRepository.logout();
      user.value = null;
      Get.offAllNamed(Routes.LOGIN);
      Helpers.showSuccessSnackbar('تم تسجيل الخروج', 'نتمنى رؤيتك مرة أخرى');
    } catch (e) {
      Helpers.showErrorSnackbar('خطأ', 'حدث خطأ أثناء تسجيل الخروج');
    } finally {
      isLoading.value = false;
    }
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _authRepository.isLoggedIn();
  }
}