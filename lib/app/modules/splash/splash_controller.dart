import 'package:get/get.dart';
// import 'package:split_money/app/core/services/storage_service.dart';
import 'package:split_money/app/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate initialization tasks
    await Future.delayed(const Duration(seconds: 2));

    // Demo navigation order: login -> onboarding -> home
    // You can change this order as needed
    Get.offAllNamed(AppRoutes.login);
    // To test onboarding, comment above and uncomment below:
    // Get.offAllNamed(AppRoutes.onboarding);
    // To test home, comment above and uncomment below:
    // Get.offAllNamed(AppRoutes.home);
  }
}
