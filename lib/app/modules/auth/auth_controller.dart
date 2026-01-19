// ==================== LOGIN CONTROLLER ====================
// File: lib/controllers/login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/modules/auth/auth_service.dart';
import 'package:split_money/app/core/theme/theme.dart';
import 'package:split_money/app/modules/auth/auth_register_view.dart';
import 'package:split_money/app/modules/auth/forget_password_view.dart';

// ==================== LOGIN CONTROLLER ====================
class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  // Forgot-password (fp) state & controllers (kept inside LoginController)
  final fpEmailController = TextEditingController();
  final fpMobileController = TextEditingController();
  final fpOtpController = TextEditingController();

  final RxBool fpUseEmail = true.obs;
  final RxBool fpShowOtp = false.obs;
  final RxBool fpIsLoading = false.obs;

  final RxString fpEmailError = ''.obs;
  final RxString fpMobileError = ''.obs;
  final RxString fpOtpError = ''.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    fpEmailController.dispose();
    fpMobileController.dispose();
    fpOtpController.dispose();
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
      Get.offAllNamed('/home');
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

  void navigateToSignup() {
    // Ensure SignupController is registered, then navigate
    if (!Get.isRegistered<SignupController>()) {
      Get.put(SignupController());
    }
    Get.to(() => const SignupScreen());
  }

  void navigateToForgetPassword() {
    // Ensure LoginController is available (should be) and navigate
    Get.to(() => const ForgetPasswordScreen());
  }

  // Forgot-password behavior implemented as methods below (use GetX state above)
  void fpSetModeEmail() => fpUseEmail.value = true;
  void fpSetModeMobile() => fpUseEmail.value = false;

  bool _fpValidateContact() {
    fpEmailError.value = '';
    fpMobileError.value = '';

    if (fpUseEmail.value) {
      if (fpEmailController.text.trim().isEmpty) {
        fpEmailError.value = 'Email is required';
        return false;
      }
      if (!GetUtils.isEmail(fpEmailController.text.trim())) {
        fpEmailError.value = 'Please enter a valid email';
        return false;
      }
    } else {
      if (fpMobileController.text.trim().isEmpty) {
        fpMobileError.value = 'Mobile number is required';
        return false;
      }
      if (fpMobileController.text.trim().length < 6) {
        fpMobileError.value = 'Enter a valid mobile number';
        return false;
      }
    }

    return true;
  }

  void fpSendOtp() {
    if (!_fpValidateContact()) return;

    fpIsLoading.value = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      fpIsLoading.value = false;
      fpShowOtp.value = true;
      Get.snackbar(
        'OTP sent',
        fpUseEmail.value
            ? 'Check your email for the OTP'
            : 'Check your mobile for the OTP',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    });
  }

  void fpVerifyOtp() {
    fpOtpError.value = '';
    if (fpOtpController.text.trim().isEmpty ||
        fpOtpController.text.trim().length < 3) {
      fpOtpError.value = 'Enter the OTP';
      return;
    }

    fpIsLoading.value = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      fpIsLoading.value = false;
      Get.snackbar(
        'Success',
        fpUseEmail.value
            ? 'Password reset link sent to your email'
            : 'Password sent to your mobile',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
      Get.back();
    });
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
