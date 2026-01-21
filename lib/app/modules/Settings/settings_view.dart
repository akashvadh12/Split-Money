import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/modules/Settings/settings_controller.dart';
import 'package:split_money/app/modules/Settings/preferences_controller.dart';
import 'package:split_money/app/modules/Settings/theme_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with TickerProviderStateMixin {
  final GlobalKey _darkSwitchKey = GlobalKey();
  bool _isAnimating = false;

  Future<void> _animateThemeTransition(
    GlobalKey switchKey,
    bool toDark,
    ThemeController themeController,
  ) async {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    // find center of the switch; fallback to center of screen
    Offset center = Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
    );
    try {
      final renderBox =
          switchKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        center = renderBox.localToGlobal(renderBox.size.center(Offset.zero));
      }
    } catch (_) {}

    final size = MediaQuery.of(context).size;
    final dx = max(center.dx, size.width - center.dx);
    final dy = max(center.dy, size.height - center.dy);
    final maxRadius = sqrt(dx * dx + dy * dy);

    if (_isAnimating) return;
    _isAnimating = true;

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    final anim = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );

    final overlayEntry = OverlayEntry(
      builder: (ctx) {
        return AnimatedBuilder(
          animation: anim,
          builder: (ctx, child) {
            final radius = toDark
                ? anim.value * maxRadius
                : (1 - anim.value) * maxRadius;
            final opacity = toDark
                ? anim.value.clamp(0.0, 0.95)
                : (anim.value).clamp(0.0, 0.95);
            final overlayColor = toDark
                ? Colors.black
                : Colors
                      .black; // keep dark overlay for both directions for smooth reveal
            return Stack(
              children: [
                Positioned(
                  left: center.dx - radius,
                  top: center.dy - radius,
                  width: radius * 2,
                  height: radius * 2,
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      decoration: BoxDecoration(
                        color: overlayColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    overlay.insert(overlayEntry);

    try {
      // Toggle theme when animation crosses halfway for a smoother handoff
      var didToggle = false;
      anim.addListener(() {
        if (!didToggle && anim.value >= 0.5) {
          didToggle = true;
          // apply theme at midpoint so the overlay doesn't sit still fully covering
          if (toDark) {
            themeController.toggleDarkMode(true);
          } else {
            themeController.toggleDarkMode(false);
          }
        }
      });

      await controller.forward();
    } finally {
      overlayEntry.remove();
      controller.dispose();
      _isAnimating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headerColor = isDark
        ? theme.colorScheme.primary
        : theme.colorScheme.primary; // theme defines sensible primary for both
    final controller = Get.put(SettingsController());
    final prefsController = Get.put(PreferencesController());
    final themeController = Get.put(ThemeController());
    // initialize theme controller based on current context
    themeController.initFromContext(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        top: false,
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
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).padding.top + 20,
                  20,
                  24,
                ),
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

                      // Preferences section (moved below Account Preferences)
                      _Section(
                        title: 'PREFERENCES',
                        children: [
                          Obx(
                            () => _SwitchSettingTile(
                              icon: Icons.notifications_none,
                              activeIcon: Icons.notifications_active,
                              bgColor: !isDark
                                  ? Colors.amber.withValues(alpha: .4)
                                  : theme.colorScheme.onPrimary,
                              title: 'Notifications',
                              value: prefsController.notificationsEnabled.value,
                              onChanged: prefsController.toggleNotifications,
                            ),
                          ),
                          Obx(
                            () => _SwitchSettingTile(
                              icon: Icons.dark_mode,
                              activeIcon: Icons.dark_mode,
                              inactiveIcon: Icons.wb_sunny,
                              bgColor: isDark
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onPrimary,
                              title: 'Dark Mode',
                              value: themeController.darkModeEnabled.value,
                              onChanged: (val) => _animateThemeTransition(
                                _darkSwitchKey,
                                val,
                                themeController,
                              ),
                              switchKey: _darkSwitchKey,
                            ),
                          ),
                        ],
                      ),

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
                            bgColor: const Color(
                              0xFFFF4639,
                            ).withValues(alpha: .8),
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

class _SwitchSettingTile extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final IconData? inactiveIcon;
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? bgColor;
  final Key? switchKey;

  const _SwitchSettingTile({
    required this.icon,
    this.activeIcon,
    this.inactiveIcon,
    required this.title,
    required this.value,
    this.onChanged,
    this.bgColor,
    this.switchKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: ScaleTransition(scale: anim, child: child),
                ),
                child: Icon(
                  // prefer active/inactive icons when provided
                  value ? (activeIcon ?? icon) : (inactiveIcon ?? icon),
                  key: ValueKey<bool>(value),
                  color: Brightness.dark != theme.brightness
                      ? Colors.black
                      : theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Switch.adaptive(key: switchKey, value: value, onChanged: onChanged),
          ],
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
