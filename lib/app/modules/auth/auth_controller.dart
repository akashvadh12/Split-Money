

// ==================== LOGIN CONTROLLER ====================
// File: lib/controllers/login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/modules/auth/auth_service.dart';

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
    if (!_validateInputs()) {
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
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
        
        // Navigate to home screen (replace with your home route)
        Get.offAllNamed('/home');
      } else {
        Get.snackbar(
          'Login Failed',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
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
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void navigateToSignup() {
    // Navigate to signup screen (replace with your signup route)
    Get.toNamed('/signup');
  }
}
