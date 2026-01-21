import 'package:get/get.dart';
import 'package:split_money/app/modules/wallet/wallet_event_history/wallet_event_breakdown.dart';

class WalletEvent {
  final String dateLabel; // e.g. 'JULY, 14 SAT'
  final String title;
  final double amount;
  final List<String> participants; // placeholder initials or image urls
  final double progress; // 0.0 - 1.0
  final int extraParticipants;
  final int status; // 0 = normal, 1 = checked
  final int colorSeed; // seed to pick background color

  WalletEvent({
    required this.dateLabel,
    required this.title,
    required this.amount,
    required this.participants,
    required this.progress,
    this.extraParticipants = 0,
    this.status = 0,
    this.colorSeed = 0,
  });
}

class WalletEventController extends GetxController {
  final currentTabIndex = 0.obs;

  final events = <WalletEvent>[
    WalletEvent(
      dateLabel: 'JULY, 14 SAT',
      title: 'Yacht Weekend',
      amount: 4250.00,
      participants: ['A', 'P', 'S'],
      extraParticipants: 8,
      progress: 0.65,
      colorSeed: 0,
    ),
    WalletEvent(
      dateLabel: 'JUNE, 28 WED',
      title: 'Beach Villa Hire',
      amount: 8900.50,
      participants: ['T', 'R', 'P'],
      extraParticipants: 12,
      progress: 0.35,
      colorSeed: 1,
    ),
    WalletEvent(
      dateLabel: 'MAY, 11 MON',
      title: 'Dinner Party',
      amount: 1240.25,
      participants: ['C', 'J'],
      extraParticipants: 3,
      progress: 0.9,
      colorSeed: 2,
    ),
  ].obs;

  void changeTab(int idx) => currentTabIndex.value = idx;

  void onEventTap(WalletEvent event) {
    // placeholder action
    Get.to(WalletEventBreakdownScreen());
    // Get.snackbar(
    //   'Event',
    //   'Tapped "${event.title}"',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }
}
