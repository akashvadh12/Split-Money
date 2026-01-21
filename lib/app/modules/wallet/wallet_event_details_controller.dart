import 'package:get/get.dart';

class Participant {
  final String name;
  final String? avatarUrl;
  final double amount;
  final String status; // 'SETTLED', 'PENDING', 'WAITING'
  final String timeLabel;

  Participant({
    required this.name,
    this.avatarUrl,
    required this.amount,
    required this.status,
    required this.timeLabel,
  });
}

class WalletEventDetailsController extends GetxController {
  final title = 'Weekend Beach Trip'.obs;
  final organizer = 'Organized by Alex Riv'.obs;
  final collected = 1500.0.obs;
  final target = 2000.0.obs;

  double get percent =>
      (collected.value / (target.value == 0 ? 1 : target.value)).clamp(
        0.0,
        1.0,
      );

  final participants = <Participant>[
    Participant(
      name: 'Sarah Jenkins',
      avatarUrl: null,
      amount: 150.0,
      status: 'SETTLED',
      timeLabel: 'Paid 2h ago',
    ),
    Participant(
      name: 'Jordan Lee',
      avatarUrl: null,
      amount: 150.0,
      status: 'SETTLED',
      timeLabel: 'Paid Yesterday',
    ),
    Participant(
      name: 'Chris Park',
      avatarUrl: null,
      amount: 120.0,
      status: 'PENDING',
      timeLabel: 'Pending',
    ),
    Participant(
      name: 'Monica Bell',
      avatarUrl: null,
      amount: 80.0,
      status: 'WAITING',
      timeLabel: 'Waiting',
    ),
  ].obs;

  void remindAllPending() {
    final pending = participants.where((p) => p.status != 'SETTLED').length;
    Get.snackbar(
      'Reminders sent',
      'Reminded $pending pending participants',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
