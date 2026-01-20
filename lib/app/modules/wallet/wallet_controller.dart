import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/modules/wallet/wallet_event_breakdown.dart';

// Controller
class WalletController extends GetxController {
  final currentTabIndex = 0.obs;

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  void addMoney() {
    Get.to(WalletEventBreakdownScreen());
  }

  void requestFunds() {
    Get.snackbar(
      'Request Funds',
      'Request funds functionality triggered',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}
