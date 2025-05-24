import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/app/data/models/auth_model.dart';
import 'package:real_estate_app/app/data/models/user_model.dart';
import 'package:real_estate_app/app/data/repositories/user_repository.dart';
import 'package:real_estate_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/app/utils/helpers.dart';

class ProfileController extends GetxController {
  final UserRepository _userRepository = Get.find<UserRepository>();
  final AuthController _authController = Get.find<AuthController>();

  // Profile form controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Password form controllers
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Form keys
  final profileFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();

  // User profile
  final user = Rxn<UserModel>();

  // Loading states
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final isChangingPassword = false.obs;

  // Password visibility
  final obscureCurrentPassword = true.obs;
  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    getUserProfile();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Get user profile
  Future<void> getUserProfile() async {
    try {
      isLoading.value = true;

      // Try to get cached profile first
      final cachedProfile = _userRepository.getCachedProfile();
      if (cachedProfile != null) {
        user.value = cachedProfile;
        _setFormValues(cachedProfile);
      }

      // Fetch latest profile data
      final profile = await _userRepository.getUserProfile();

      user.value = profile;
      _setFormValues(profile);
    } catch (e) {
      Helpers.showErrorSnackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Set form values from user profile
  void _setFormValues(UserModel user) {
    fullNameController.text = user.fullName;
    phoneController.text = user.phoneNumber;
    emailController.text = user.email;
  }

  // Update user profile
  Future<void> updateProfile() async {
    if (!profileFormKey.currentState!.validate()) {
      return;
    }

    try {
      isUpdating.value = true;

      final updatedProfile = await _userRepository.updateUserProfile(
        fullName: fullNameController.text,
        phoneNumber: phoneController.text,
        email: emailController.text,
      );

      user.value = updatedProfile;

      // Update auth controller user data
      _authController.user.value = updatedProfile;

      Helpers.showSuccessSnackbar(
        'تم تحديث الملف الشخصي',
        'تم تحديث بياناتك بنجاح',
      );
    } catch (e) {
      Helpers.showErrorSnackbar('خطأ', e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  // Change password
  Future<void> changePassword() async {
    if (!passwordFormKey.currentState!.validate()) {
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Helpers.showErrorSnackbar('خطأ', 'كلمة المرور الجديدة غير متطابقة');
      return;
    }

    try {
      isChangingPassword.value = true;

      final request = ChangePasswordRequest(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmNewPassword: confirmPasswordController.text,
      );

      final success = await _userRepository.changePassword(request);

      if (success) {
        // Clear form fields
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        Helpers.showSuccessSnackbar(
          'تم تغيير كلمة المرور',
          'تم تغيير كلمة المرور بنجاح',
        );

        // Navigate back
        Get.back();
      } else {
        Helpers.showErrorSnackbar('خطأ', 'فشل تغيير كلمة المرور');
      }
    } catch (e) {
      Helpers.showErrorSnackbar('خطأ', e.toString());
    } finally {
      isChangingPassword.value = false;
    }
  }

  // Toggle current password visibility
  void toggleCurrentPasswordVisibility() {
    obscureCurrentPassword.value = !obscureCurrentPassword.value;
  }

  // Toggle new password visibility
  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }
}