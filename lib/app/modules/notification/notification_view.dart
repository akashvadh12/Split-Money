import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notification_controller.dart';

class NotificationsView extends GetView<NotificationController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: theme.colorScheme.onSurface,
                        ),
                        onPressed: () => Get.back(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifications',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Stay updated with your group',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                .7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.surface,
                    child: IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        color: theme.colorScheme.onSurface,
                      ),
                      onPressed: () => Get.snackbar('Not implemented', 'Menu'),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                final items = controller.notifications;
                // split into Today / Yesterday for demo based on index
                final today = items.take(2).toList();
                final yesterday = items.skip(2).toList();

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel(
                        label: 'TODAY',
                        actionText: 'Mark all read',
                        onAction: controller.markAllRead,
                      ),
                      const SizedBox(height: 12),
                      ...today.map(
                        (n) => Dismissible(
                          key: ValueKey(n.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (c) => AlertDialog(
                                title: const Text('Delete notification?'),
                                content: const Text(
                                  'Are you sure you want to delete this notification?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(c).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(c).pop(true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              controller.removeNotification(n.id);
                              return true;
                            }
                            return false;
                          },
                          child: _NotificationCard(
                            item: n,
                            controller: controller,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      _SectionLabel(label: 'YESTERDAY'),
                      const SizedBox(height: 12),
                      ...yesterday.map(
                        (n) => Dismissible(
                          key: ValueKey(n.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (c) => AlertDialog(
                                title: const Text('Delete notification?'),
                                content: const Text(
                                  'Are you sure you want to delete this notification?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(c).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(c).pop(true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              controller.removeNotification(n.id);
                              return true;
                            }
                            return false;
                          },
                          child: _NotificationCard(
                            item: n,
                            controller: controller,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: controller.archiveOlder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface,
                            foregroundColor: theme.colorScheme.onSurface,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 20,
                            ),
                            child: Text(
                              'OLDER NOTIFICATIONS ARE ARCHIVED'.toUpperCase(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final String? actionText;
  final VoidCallback? onAction;
  const _SectionLabel({required this.label, this.actionText, this.onAction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(.6),
            fontWeight: FontWeight.w700,
          ),
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final NotificationController controller;
  const _NotificationCard({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primaryContainer.withOpacity(.25),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withOpacity(0.6)
                : Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.event_note,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item.timeAgo,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(item.message, style: theme.textTheme.bodyMedium),
                    if (item.actionable) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => controller.acceptInvite(item),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Accept'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () => controller.declineInvite(item),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Decline'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
