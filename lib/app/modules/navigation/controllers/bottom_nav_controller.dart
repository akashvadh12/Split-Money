import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

class BottomNavController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  late final NotchBottomBarController notchBottomBarController;
  late final PageController pageController;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onInit() {
    super.onInit();

    pageController = PageController(initialPage: 0);
    notchBottomBarController = NotchBottomBarController(index: 0);
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.closeDrawer();
  }

  /// 🔥 SINGLE SOURCE OF TAB CHANGE
  void changeTab(int index) {
    if (index == selectedIndex.value) return;

    selectedIndex.value = index;

    // Animate page transition for smooth effect
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
    // Let AnimatedNotchBottomBar handle its own animation when user taps the bar.
    // We don't force-jump the notch here to avoid interrupting its built-in animation.
  }

  @override
  void onClose() {
    pageController.dispose();
    notchBottomBarController.dispose();
    super.onClose();
  }
}
