import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Direct navigation after delay
    Future.delayed(const Duration(seconds: 2), () {
      // to test login, comment below and uncomment next line:
      Get.offAllNamed(AppRoutes.login);
      // To test home, comment above and uncomment below:
      // Get.offAllNamed(AppRoutes.home);
      // To test onboarding, comment above and uncomment below:
      // Get.offAllNamed(AppRoutes.onboarding);
    });
    return Scaffold(
      backgroundColor: const Color(0xFF2F2F2F),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF2F2F2F), const Color(0xFF1A1C1E)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFCCE5E3),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCCE5E3).withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.receipt_long,
                  size: 64,
                  color: Color(0xFF2F2F2F),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Event Manager',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Organize & Collect Effortlessly',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.7),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFFCCE5E3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
