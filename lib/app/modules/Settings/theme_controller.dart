import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final darkModeEnabled = false.obs;

  /// Initialize from current theme if available
  void initFromContext(BuildContext context) {
    darkModeEnabled.value = Theme.of(context).brightness == Brightness.dark;
  }

  void toggleDarkMode(bool value) {
    darkModeEnabled.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
}
