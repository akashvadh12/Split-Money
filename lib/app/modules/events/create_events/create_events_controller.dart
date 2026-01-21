import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/core/theme/theme.dart';
import 'package:split_money/app/modules/events/create_events/when&where/when&where.dart';

// Controller
class CreateEventController extends GetxController {
  final eventTitleController = TextEditingController();
  final descriptionController = TextEditingController();
  
  final selectedCategory = Rx<EventCategory?>(null);
  final currentStep = 1.obs;
  
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

  void selectCategory(EventCategory category) {
    selectedCategory.value = category;
  }

  bool get canContinue {
    return eventTitleController.text.isNotEmpty && 
           selectedCategory.value != null;
  }

  void onContinue() {
    if (canContinue) {
      // Navigate to next step or save data
   Get.to(WhenWhereScreen());
    }
  }

  @override
  void onClose() {
    eventTitleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}

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
}
