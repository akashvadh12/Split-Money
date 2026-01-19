import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/modules/auth/auth_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Dark header section
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF2F2F2F),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(32, 40, 32, 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF404040),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Welcome text
                    const Text(
                      'Welcome\nBack',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Organize your group events and collect\ncontributions effortlessly.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Light form section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A1C1E)
                      : const Color(0xFFF7F9F8),
                ),
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email field
                    Text(
                      'EMAIL OR MOBILE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFF8A9291)
                            : const Color(0xFF707978),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => TextField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter your Email',
                          hintStyle: TextStyle(
                            color: isDark
                                ? const Color(0xFF8A9291)
                                : const Color(0xFF707978),
                          ),
                          suffixIcon: Icon(
                            Icons.alternate_email,
                            color: isDark
                                ? const Color(0xFF8A9291)
                                : const Color(0xFF707978),
                          ),
                          filled: true,
                          fillColor: isDark
                              ? const Color(0xFF222427)
                              : theme.colorScheme.primary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          errorText: controller.emailError.value.isEmpty
                              ? null
                              : controller.emailError.value,
                          contentPadding: const EdgeInsets.all(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Password field
                    Text(
                      'PASSWORD',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFF8A9291)
                            : const Color(0xFF707978),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => TextField(
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        decoration: InputDecoration(
                          hintText: 'Enter your Password',
                          hintStyle: TextStyle(
                            color: isDark
                                ? const Color(0xFF8A9291)
                                : const Color(0xFF707978),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: isDark
                                  ? const Color.fromARGB(255, 138, 146, 145)
                                  : const Color(0xFF707978),
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? const Color(0xFF222427)
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          errorText: controller.passwordError.value.isEmpty
                              ? null
                              : controller.passwordError.value,
                          contentPadding: const EdgeInsets.all(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: controller.forgotPassword,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFF8A9291)
                                : const Color(0xFF707978),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Login button
                    Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F2F2F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          disabledBackgroundColor: const Color(0xFF707978),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Create account
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'New around here?',
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFF8A9291)
                                  : const Color(0xFF707978),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: controller.navigateToSignup,
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                color: isDark
                                    ? const Color(0xFFE2E2E2)
                                    : const Color(0xFF2F2F2F),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
