import 'package:get/get.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final String category; // e.g., invite, payment, info
  final bool actionable;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    this.category = 'info',
    this.actionable = false,
  });
}

class NotificationController extends GetxController {
  final notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    // seed with sample data
    notifications.addAll([
      NotificationItem(
        id: 'n1',
        title: 'Summer Trip 2024',
        message: 'Alex invited you to "Weekend Cabin Trip" collection.',
        timeAgo: '2m ago',
        category: 'invite',
        actionable: true,
      ),
      NotificationItem(
        id: 'n2',
        title: 'Payment Received',
        message: 'Sarah sent \$45.00 for "Dinner at Amigo\'s".',
        timeAgo: '1h ago',
        category: 'payment',
      ),
      NotificationItem(
        id: 'n3',
        title: 'Collection Goal Reached',
        message: '"Office Party" has reached its goal of \$500.00!',
        timeAgo: '1d ago',
        category: 'goal',
      ),
      NotificationItem(
        id: 'n4',
        title: 'Transfer Successful',
        message:
            'Your transfer of \$120.00 to Bank Account ending in \u002A4221 is complete.',
        timeAgo: '1d ago',
        category: 'payment',
      ),
    ]);
  }

  void markAllRead() {
    Get.snackbar('Marked', 'All notifications marked read');
  }

  void acceptInvite(NotificationItem item) {
    Get.snackbar('Accepted', 'Accepted invite: ${item.title}');
  }

  void declineInvite(NotificationItem item) {
    Get.snackbar('Declined', 'Declined invite: ${item.title}');
  }

  void archiveOlder() {
    Get.snackbar('Archived', 'Older notifications archived');
  }

  void removeNotification(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final removed = notifications.removeAt(index);
      Get.snackbar('Deleted', '${removed.title} deleted');
    }
  }
}
