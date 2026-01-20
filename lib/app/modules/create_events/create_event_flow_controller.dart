import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/modules/create_events/create_events.dart';
import 'package:split_money/app/modules/create_events/when&where/when&where.dart';
import 'package:split_money/app/modules/create_events/amount_and_split/amount_and_split_screen.dart';

/// Centralized controller for managing the entire Create Event flow
/// Handles navigation, step tracking, and data persistence across all screens
class CreateEventFlowController extends GetxController {
  // Current step tracking (1-based indexing for UI display)
  final currentStep = 1.obs;
  final totalSteps = 3;

  // Screen 1: Basic Event Info
  final eventTitleController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedCategory = Rx<EventCategory?>(null);
  final isTitleValid = false.obs; // Track title validity

  // Screen 2: When & Where
  final selectedDate = Rx<DateTime>(DateTime.now());
  final startTime = Rx<TimeOfDay>(const TimeOfDay(hour: 19, minute: 30));
  final endTime = Rx<TimeOfDay>(const TimeOfDay(hour: 23, minute: 0));
  final locationController = TextEditingController();

  // Screen 3: Amount & Split
  final totalAmountController = TextEditingController(text: '0');
  final vendorNameController = TextEditingController();
  final selectedDeadline = Rx<DateTime>(
    DateTime.now().add(const Duration(days: 4)),
  );
  final selectedDueDate = Rx<DateTime>(
    DateTime.now().add(const Duration(days: 4)),
  );
  final participantSlots = 12.obs;
  final remindersEnabled = true.obs;
  final selectedSplitType = Rx<SplitType?>(null);
  final eventCategory = 'Food'.obs;

  // Categories
  final categories = <EventCategory>[
    EventCategory(
      name: 'Trip',
      icon: Icons.flight_takeoff,
      color: const Color(0xFFCCE5E3),
    ),
    EventCategory(
      name: 'Party',
      icon: Icons.celebration,
      color: const Color(0xFFFEE1B6),
    ),
    EventCategory(
      name: 'Gift',
      icon: Icons.card_giftcard,
      color: const Color(0xFFB9C6D7),
    ),
    EventCategory(
      name: 'Other',
      icon: Icons.more_horiz,
      color: Colors.white,
      isOutlined: true,
    ),
  ];

  final eventCategories = [
    'Food',
    'Transport',
    'Accommodation',
    'Entertainment',
    'Other',
  ];

  // Computed properties
  String get timeLeft {
    final now = DateTime.now();
    final difference = selectedDeadline.value.difference(now);
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    return '$days Days, ${hours}H';
  }

  List<DateTime> get weekDates {
    final List<DateTime> dates = [];
    final now = selectedDate.value;
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    for (int i = 0; i < 5; i++) {
      dates.add(startOfWeek.add(Duration(days: i)));
    }
    return dates;
  }

  // Step 1 validation
  bool get canContinueStep1 {
    return isTitleValid.value && selectedCategory.value != null;
  }

  // Step 2 validation
  bool get canContinueStep2 {
    return true; // Can always continue from step 2
  }

  // Step 3 validation
  bool get canContinueStep3 {
    return selectedSplitType.value != null;
  }

  // Navigation methods
  void goToStep1() {
    currentStep.value = 1;
    Get.off(() => const CreateEventScreen());
  }

  void goToStep2() {
    if (!canContinueStep1) {
      Get.snackbar(
        'Incomplete',
        'Please fill in event title and select a category',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    currentStep.value = 2;
    Get.to(() => const WhenWhereScreen());
  }

  void goToStep3() {
    if (!canContinueStep2) {
      return;
    }
    currentStep.value = 3;
    Get.to(() => const CompleteEventSetupScreen());
  }

  void goToPreviousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
      Get.back();
    }
  }

  void completeFlow() {
    if (!canContinueStep3) {
      Get.snackbar(
        'Incomplete',
        'Please select a split type',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Show success message
    Get.snackbar(
      'Success',
      'Event "${eventTitleController.text}" created successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );

    // Navigate back or to event details
    Get.back();
    Get.back();
    Get.back();
  }

  // Category selection
  void selectCategory(EventCategory category) {
    selectedCategory.value = category;
  }

  // Date & Time methods
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

  // Amount & Split methods
  void updateParticipantSlots(double value) {
    participantSlots.value = value.round();
  }

  void toggleReminders() {
    remindersEnabled.value = !remindersEnabled.value;
  }

  void selectSplitType(SplitType type) {
    selectedSplitType.value = type;
  }

  // Reset flow
  void resetFlow() {
    currentStep.value = 1;
    eventTitleController.clear();
    descriptionController.clear();
    selectedCategory.value = null;
    locationController.clear();
    totalAmountController.text = '0';
    vendorNameController.clear();
    selectedSplitType.value = null;
    isTitleValid.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    // Add listener to track title changes
    eventTitleController.addListener(() {
      isTitleValid.value = eventTitleController.text.isNotEmpty;
    });
  }

  @override
  void onClose() {
    eventTitleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    totalAmountController.dispose();
    vendorNameController.dispose();
    super.onClose();
  }
}

// Event Category Model
class EventCategory {
  final String name;
  final IconData icon;
  final Color color;
  final bool isOutlined;

  EventCategory({
    required this.name,
    required this.icon,
    required this.color,
    this.isOutlined = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventCategory &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

// Split Type Enum
enum SplitType { fixedPerPerson, splitEqually }
