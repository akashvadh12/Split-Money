import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:split_money/app/core/theme/theme.dart';

// Controller
class CompleteEventSetupController extends GetxController {
  final totalAmountController = TextEditingController(text: '1,250');
  final vendorNameController = TextEditingController();
  
  final selectedDeadline = Rx<DateTime>(DateTime.now().add(const Duration(days: 4)));
  final participantSlots = 12.obs;
  final remindersEnabled = true.obs;
  final selectedSplitType = Rx<SplitType?>(null);
  final selectedCategory = 'Food'.obs;
  final selectedDueDate = Rx<DateTime>(DateTime.now().add(const Duration(days: 4)));

  final categories = ['Food', 'Transport', 'Accommodation', 'Entertainment', 'Other'];

  String get timeLeft {
    final now = DateTime.now();
    final difference = selectedDeadline.value.difference(now);
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    return '$days Days, ${hours}H';
  }

  void updateParticipantSlots(double value) {
    participantSlots.value = value.round();
  }

  void toggleReminders() {
    remindersEnabled.value = !remindersEnabled.value;
  }

  void selectSplitType(SplitType type) {
    selectedSplitType.value = type;
  }

  Future<void> pickDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDeadline.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      selectedDeadline.value = picked;
    }
  }

  Future<void> pickDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      selectedDueDate.value = picked;
    }
  }

  void onContinue() {
    if (selectedSplitType.value != null) {
      Get.snackbar(
        'Success',
        'Event setup completed with ${selectedSplitType.value?.name} split',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.success,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  @override
  void onClose() {
    totalAmountController.dispose();
    vendorNameController.dispose();
    super.onClose();
  }
}

enum SplitType {
  fixedPerPerson,
  splitEqually,
}
