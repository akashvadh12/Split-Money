// ==================== HOME CONTROLLER ====================
// File: lib/controllers/home_controller.dart

import 'package:get/get.dart';
import 'package:split_money/app/modules/auth/auth_service.dart';

class Event {
  final String id;
  final String title;
  final String date;
  final String icon;
  final int participants;
  final double collected;
  final double target;
  final List<String> avatars;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.icon,
    required this.participants,
    required this.collected,
    required this.target,
    required this.avatars,
  });

  double get progress => (collected / target).clamp(0.0, 1.0);
}

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  final RxList<Event> upcomingEvents = <Event>[].obs;
  final RxInt activeEventsCount = 12.obs;
  final RxDouble totalCollected = 4850.0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  String get userName {
    final email = _authService.currentUserEmail.value ?? '';
    if (email.isEmpty) return 'User';
    return 'Sarah Jenkins'; // Mock user name
  }

  void loadData() {
    // Mock data - replace with API call
    upcomingEvents.value = [
      Event(
        id: '1',
        title: 'Bistro Dinner Night',
        date: 'July, 14 Sat • 8 People',
        icon: '🍴',
        participants: 8,
        collected: 420.00,
        target: 600.00,
        avatars: ['👨', '👩', '+6'],
      ),
      Event(
        id: '2',
        title: 'Weekend Getaway',
        date: 'Aug, 02 Fri • 4 People',
        icon: '✈️',
        participants: 4,
        collected: 1850.00,
        target: 2000.00,
        avatars: ['👨', '👩'],
      ),
    ];
  }

  void refreshData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    loadData();
    isLoading.value = false;
  }

  void navigateToEventDetails(Event event) {
    Get.toNamed('/event-details', arguments: event);
  }

  void navigateToAllEvents() {
    Get.toNamed('/events');
  }

  void logout() async {
    await _authService.logout();
    Get.offAllNamed('/login');
  }
}
