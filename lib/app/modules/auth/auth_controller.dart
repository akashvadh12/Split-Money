// ==================== LOGIN CONTROLLER ====================
// File: lib/app/modules/auth/auth_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:split_money/app/modules/auth/auth_service.dart';
import 'package:split_money/app/modules/auth/auth_register_view.dart';
import 'package:split_money/app/modules/auth/forget_password_view.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  // ==================== FORGOT PASSWORD ====================
  final fpEmailController = TextEditingController();
  final fpMobileController = TextEditingController();

  final FocusNode fpEmailFocusNode = FocusNode();
  final FocusNode fpMobileFocusNode = FocusNode();

  final List<TextEditingController> fpOtpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> fpOtpFocusNodes = List.generate(6, (_) => FocusNode());

  final RxBool fpUseEmail = true.obs;
  final RxBool fpShowOtp = false.obs;
  final RxBool fpIsLoading = false.obs;

  final RxString fpEmailError = ''.obs;
  final RxString fpMobileError = ''.obs;
  final RxString fpOtpError = ''.obs;

  final RegExp _emailRegex = RegExp(
    r'^[\w\.\-]+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,}$',
  );

  // ==================== LIFECYCLE ====================
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    fpEmailController.dispose();
    fpMobileController.dispose();
    fpEmailFocusNode.dispose();
    fpMobileFocusNode.dispose();

    for (final c in fpOtpControllers) {
      c.dispose();
    }
    for (final f in fpOtpFocusNodes) {
      f.dispose();
    }

    super.onClose();
  }

  // ==================== LOGIN ====================
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  bool _validateInputs() {
    emailError.value = '';
    passwordError.value = '';
    bool valid = true;

    if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Enter a valid email';
      valid = false;
    }

    if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      valid = false;
    }

    return valid;
  }

  /// ✅ RESTORED (FIX)
  Future<void> login() async {
    if (!_validateInputs()) return;

    isLoading.value = true;

    try {
      final result = await _authService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (result['success']) {
        Get.offAllNamed('/main');
      } else {
        Get.snackbar(
          'Login failed',
          result['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Theme.of(
            Get.context!,
          ).colorScheme.error.withValues(alpha: 0.7),
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== NAVIGATION ====================
  void navigateToSignup() {
    if (!Get.isRegistered<SignupController>()) {
      Get.put(SignupController());
    }
    Get.to(() => const SignupScreen());
  }

  void navigateToForgetPassword() {
    Get.to(() => const ForgetPasswordScreen());
  }

  // ==================== FORGOT PASSWORD MODE SWITCH ====================
  void fpSetModeEmail({bool requestFocus = true}) {
    fpUseEmail.value = true;
    _resetFpState();
    if (requestFocus) _forceKeyboardSwitch(fpEmailFocusNode);
  }

  void fpSetModeMobile({bool requestFocus = true}) {
    fpUseEmail.value = false;
    _resetFpState();
    if (requestFocus) _forceKeyboardSwitch(fpMobileFocusNode);
  }

  void _resetFpState() {
    fpEmailError.value = '';
    fpMobileError.value = '';
    fpOtpError.value = '';
    fpShowOtp.value = false;

    for (final c in fpOtpControllers) {
      c.clear();
    }
  }

  void _forceKeyboardSwitch(FocusNode node) {
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 120), () {
        if (!node.hasFocus) node.requestFocus();
      });
    });
  }

  // ==================== FORGOT PASSWORD FLOW ====================
  bool _fpValidateContact() {
    fpEmailError.value = '';
    fpMobileError.value = '';

    if (fpUseEmail.value) {
      if (!_emailRegex.hasMatch(fpEmailController.text.trim())) {
        fpEmailError.value = 'Enter a valid email';
        return false;
      }
    } else {
      if (!RegExp(r'^\d{6,15}$').hasMatch(fpMobileController.text.trim())) {
        fpMobileError.value = 'Enter a valid mobile number';
        return false;
      }
    }
    return true;
  }

  void fpSendOtp() {
    if (!_fpValidateContact()) return;
    fpShowOtp.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fpOtpFocusNodes.first.requestFocus();
    });
  }

  void fpVerifyOtp() {
    final otp = fpOtpControllers.map((c) => c.text).join();
    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      fpOtpError.value = 'Enter 6-digit OTP';
      return;
    }
    Get.back();
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

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirm() {
    obscureConfirm.value = !obscureConfirm.value;
  }

  bool validate() {
    if (confirmController.text != passwordController.text) {
      confirmError.value = 'Passwords do not match';
      return false;
    }
    return true;
  }

  /// ✅ RESTORED (FIX)
  void submit() {
    if (!validate()) return;
    Get.back();
  }
}
