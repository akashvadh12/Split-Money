import 'package:get/get.dart';
import 'package:split_money/app/modules/auth/auth_binding.dart';
import 'package:split_money/app/modules/auth/auth_login_view.dart';
import 'package:split_money/app/modules/auth/auth_register_view.dart';
import 'package:split_money/app/modules/home/home_binding.dart';
import 'package:split_money/app/modules/home/home_view.dart';
import 'package:split_money/app/modules/navigation/bindings/bottom_nav_binding.dart';
import 'package:split_money/app/modules/navigation/views/main_screen.dart';
import 'package:split_money/app/modules/splash/splash_binding.dart';
import 'package:split_money/app/modules/splash/splash_screen.dart';

import 'package:split_money/app/modules/Intro_screens/views/onboarding_view.dart';
import 'package:split_money/app/modules/Intro_screens/bindings/onboarding_binding.dart';
import 'package:split_money/main.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    // Splash
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    // Onboarding
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    // Login
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      binding: SignupBinding(),
    ),
    // GetPage(

    //   name: AppRoutes.splash,
    //   page: () => const HomeView(),
    //   // binding: SplashBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.onboarding,
    //   page: () => const OnboardingView(),
    //   binding: OnboardingBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.login,
    //   page: () => const LoginView(),
    //   binding: AuthBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.forgotPassword,
    //   page: () => const ForgotPasswordView(),
    //   binding: AuthBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.signup,
    //   page: () => const SignupView(),
    //   binding: AuthBinding(),
    // ),
    // Forgot Password (uncomment and implement ForgotPasswordView and AuthBinding if available)
    // GetPage(
    //   name: AppRoutes.forgotPassword,
    //   page: () => const ForgotPasswordView(),
    //   binding: AuthBinding(),
    // ),
    // Location (uncomment and implement LocationView and LocationBinding if available)
    // GetPage(
    //   name: AppRoutes.location,
    //   page: () => const LocationView(),
    //   binding: LocationBinding(),
    // ),
    // Main navigation (bottom nav)
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
      binding: BottomNavBinding(),
    ),
    // Home
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    // Add more routes as needed (profile, editProfile, etc.)
  ];
}
