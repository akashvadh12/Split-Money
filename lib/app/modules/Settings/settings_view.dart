import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/modules/Settings/settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headerColor = isDark
        ? theme.colorScheme.primary
        : theme.colorScheme.primary; // theme defines sensible primary for both
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed clipped header
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                color: headerColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title & subtitle on the left
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Settings',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Manage your group finances & account',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary.withOpacity(
                                  0.85,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Right icons
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: theme.colorScheme.onPrimary
                                  .withOpacity(0.08),
                              child: IconButton(
                                icon: Icon(
                                  Icons.notifications_none,
                                  size: 20,
                                  color: theme.colorScheme.onPrimary,
                                ),
                                onPressed: controller.onNotifications,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: theme.colorScheme.onPrimary
                                  .withOpacity(0.08),
                              backgroundImage: const NetworkImage(
                                'https://media.licdn.com/dms/image/v2/D4D03AQHLVGIVaL9i3A/profile-displayphoto-scale_200_200/B4DZlENDaYJYAc-/0/1757785898710?e=2147483647&v=beta&t=69OvRM_VA0P8Hb020ubfCOxTtJuKUUCNCeP5pYLBaY4',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable body below header
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _Section(
                        title: 'ACCOUNT PREFERENCES',
                        children: [
                          _SettingTile(
                            icon: Icons.person_outline,
                            title: 'Profile Information',
                            bgColor: isDark
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.primaryContainer,
                            onTap: controller.onProfileTap,
                          ),
                          _SettingTile(
                            icon: Icons.account_balance_wallet_outlined,
                            title: 'Payment Methods',
                            bgColor: isDark
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.secondary,
                            onTap: controller.onPaymentTap,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _Section(
                        title: 'APPLICATION',
                        children: [
                          _SettingTile(
                            icon: Icons.help_outline,
                            title: 'Help / Support',
                            bgColor: theme.colorScheme.surface,
                            onTap: controller.onHelpTap,
                          ),
                          _SettingTile(
                            icon: Icons.description_outlined,
                            title: 'Terms & Privacy',
                            bgColor: theme.colorScheme.surface,
                            onTap: controller.onTermsTap,
                          ),
                          _SettingTile(
                            icon: Icons.logout,
                            title: 'Logout',
                            bgColor: const Color.fromARGB(255, 255, 70, 57),
                            onTap: controller.onLogout,
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? bgColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    this.textColor,
    this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: .4),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.09)
                    : Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: bgColor ?? theme.colorScheme.primaryContainer,
                child: Icon(
                  icon,
                  color: Brightness.dark != theme.brightness
                      ? Colors.black
                      : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor ?? theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: textColor ?? theme.dividerColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: .7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ..._withDividers(children, theme.dividerColor.withValues(alpha: .5)),
        ],
      ),
    );
  }

  List<Widget> _withDividers(List<Widget> items, Color dividerColor) {
    final widgets = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      widgets.add(items[i]);
      if (i != items.length - 1) {
        widgets.add(const SizedBox(height: 8));
        widgets.add(Divider(color: dividerColor, height: 1));
        widgets.add(const SizedBox(height: 8));
      }
    }
    return widgets;
  }
}
