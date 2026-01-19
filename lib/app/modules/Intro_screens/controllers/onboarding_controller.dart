import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/core/services/storage_service.dart';
import 'package:split_money/app/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final StorageService _storage = StorageService();
  final currentPage = 0.obs;
  late PageController pageController;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Split Expenses Easily',
      description:
          'Split bills and shared expenses with friends, family, or roommates in just a few taps.',
      imageAsset: 'assets/data/money hand.json',
    ),
    OnboardingPage(
      title: 'Track Every Payment',
      description:
          'Keep track of who paid what and who owes whom. No more confusion or awkward reminders.',
      lottieAsset: 'assets/data/Wallet.json',
    ),
    OnboardingPage(
      title: 'Settle Up Instantly',
      description:
          'Clear balances quickly and stay stress-free. Simple, transparent, and reliable money sharing.',
      lottieAsset: 'assets/data/money hand.json',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void skip() {
    _completeOnboarding();
  }

  void next() {
    if (currentPage.value < pages.length - 1) {
      pageController.animateToPage(
        currentPage.value + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    // Mark onboarding as completed
    _storage.setFirstTime(false);

    // Navigate to login after onboarding
    Get.offAllNamed(AppRoutes.login);
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String? imageAsset;
  final String? lottieAsset;

  OnboardingPage({
    required this.title,
    required this.description,
    this.imageAsset,
    this.lottieAsset,
  });
}
