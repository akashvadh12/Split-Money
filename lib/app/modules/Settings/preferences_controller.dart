import 'package:get/get.dart';

class PreferencesController extends GetxController {
  final notificationsEnabled = true.obs;

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    // persist preference or trigger notification service updates here
  }
}
