// ==================== LOGIN CONTROLLER ====================
// File: lib/controllers/login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/modules/auth/auth_service.dart';
import 'package:split_money/app/core/theme/theme.dart';
import 'package:split_money/app/modules/auth/auth_register_view.dart';

// ==================== LOGIN CONTROLLER ====================
class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  bool _validateInputs() {
    bool isValid = true;
    emailError.value = '';
    passwordError.value = '';

    // Email validation
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }

    // Password validation
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    }

    return isValid;
  }

  Future<void> login() async {
    // If validation fails, stop early.
    if (!_validateInputs()) {
      return;
    }

    // Dev/local dummy credentials — bypass auth during development.
    if ((emailController.text == "dewashish@gmail.com" &&
            passwordController.text == "Test@1234") ||
        (emailController.text == "akash@gmail.com" &&
            passwordController.text == "Test@123")) {
      Get.offAllNamed('/main');
      return;
    }

    isLoading.value = true;

    try {
      final result = await _authService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (result['success']) {
        Get.snackbar(
          'Success',
          result['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Theme.of(
            Get.context!,
          ).success.withValues(alpha: 0.4),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );

        // Navigate to home screen (replace with your home route)
        Get.offAllNamed('/main');
      } else {
        Get.snackbar(
          'Login Failed',
          result['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Theme.of(
            Get.context!,
          ).colorScheme.error.withValues(alpha: 0.4),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void forgotPassword() {
    Get.snackbar(
      'Info',
      'Forgot password feature will be available soon',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void navigateToSignup() {
    // Ensure SignupController is registered, then navigate
    if (!Get.isRegistered<SignupController>()) {
      Get.put(SignupController());
    }
    Get.to(() => const SignupScreen());
  }
}

// ==================== SIGNUP CONTROLLER ====================
class SignupController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirm = true.obs;

  final RxString fullNameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString mobileError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString confirmError = ''.obs;

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.onClose();
  }

  void togglePassword() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirm() => obscureConfirm.value = !obscureConfirm.value;

  bool validate() {
    var valid = true;
    fullNameError.value = '';
    emailError.value = '';
    mobileError.value = '';
    passwordError.value = '';
    confirmError.value = '';

    if (fullNameController.text.trim().isEmpty) {
      fullNameError.value = 'Full name is required';
      valid = false;
    }
    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Valid email is required';
      valid = false;
    }
    if (mobileController.text.trim().isEmpty) {
      mobileError.value = 'Mobile number is required';
      valid = false;
    }
    if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      valid = false;
    }
    if (confirmController.text != passwordController.text) {
      confirmError.value = 'Passwords do not match';
      valid = false;
    }

    return valid;
  }

  void submit() {
    if (!validate()) return;

    Get.snackbar(
      'Account created',
      'Your account has been created successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Theme.of(Get.context!).success.withValues(alpha: 0.15),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );

    Get.back();
  }
}
