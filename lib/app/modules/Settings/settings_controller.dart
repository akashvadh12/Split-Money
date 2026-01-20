import 'package:get/get.dart';
import 'package:split_money/app/routes/app_routes.dart';
import 'package:split_money/app/modules/notification/notification_view.dart';

class SettingsController extends GetxController {
  void onBack() {
    Get.back();
  }

  void onNotifications() {
    Get.to(() => const NotificationsView());
  }

  void onProfileTap() {
    Get.toNamed(AppRoutes.profile);
  }

  void onPaymentTap() {
    Get.snackbar('Not implemented', 'Payment methods are not implemented yet');
  }

  void onHelpTap() {
    Get.snackbar('Not implemented', 'Help & Support is not implemented yet');
  }

  void onTermsTap() {
    Get.snackbar('Not implemented', 'Terms & Privacy is not implemented yet');
  }

  void onLogout() {
    Get.snackbar('Not implemented', 'Logout flow is not implemented yet');
  }
}
