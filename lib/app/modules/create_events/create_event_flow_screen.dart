import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/modules/create_events/create_event_flow_controller.dart';
import 'package:split_money/app/modules/create_events/create_events.dart';

/// Main entry point for the Create Event Flow
/// This initializes the centralized flow controller and displays the first screen
class CreateEventFlowScreen extends StatelessWidget {
  const CreateEventFlowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the centralized flow controller
    Get.put(CreateEventFlowController());

    // Display the first screen
    return const CreateEventScreen();
  }
}
