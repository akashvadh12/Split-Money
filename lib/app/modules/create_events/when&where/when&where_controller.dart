import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/core/theme/theme.dart';
import 'package:split_money/app/modules/create_events/amount_and_split/amount_and_split_screen.dart';

// Controller
class WhenWhereController extends GetxController {
  final selectedDate = Rx<DateTime>(DateTime.now());
  final startTime = Rx<TimeOfDay>(const TimeOfDay(hour: 19, minute: 30));
  final endTime = Rx<TimeOfDay>(const TimeOfDay(hour: 23, minute: 0));
  final locationController = TextEditingController();

  List<DateTime> get weekDates {
    final List<DateTime> dates = [];
    final now = selectedDate.value;
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    
    for (int i = 0; i < 5; i++) {
      dates.add(startOfWeek.add(Duration(days: i)));
    }
    return dates;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> pickStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime.value,
    );
    if (picked != null) {
      startTime.value = picked;
    }
  }

  Future<void> pickEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime.value,
    );
    if (picked != null) {
      endTime.value = picked;
    }
  }

  void onNextStep() {
  Get.to(CompleteEventSetupScreen());
  }

  @override
  void onClose() {
    locationController.dispose();
    super.onClose();
  }
}

// Main Screen
