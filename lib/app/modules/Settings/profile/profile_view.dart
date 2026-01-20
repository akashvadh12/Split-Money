import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/modules/Settings/profile/profile_controller.dart';
import 'edit profile/edit_profile.dart';
import 'package:split_money/app/routes/app_routes.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isdark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Profile Image with badge
                    const SizedBox(height: 40),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: !isdark
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.2),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Top action row: back (left) and edit (right)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.8),
                                  size: 20,
                                ),
                                onPressed: () {
                                  Get.offAllNamed(AppRoutes.settings);
                                },
                              ),
                              IconButton(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  Icons.mode_edit_outline,
                                  size: 22,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.8),
                                ),
                                onPressed: () {
                                  Get.to(() => const EditProfileView());
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundImage: NetworkImage(
                                    // 'assets/images/profile.png',
                                    "https://media.licdn.com/dms/image/v2/D4D03AQHLVGIVaL9i3A/profile-displayphoto-scale_200_200/B4DZlENDaYJYAc-/0/1757785898710?e=2147483647&v=beta&t=69OvRM_VA0P8Hb020ubfCOxTtJuKUUCNCeP5pYLBaY4",
                                  ), // Replace with your asset
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(
                                    Icons.verified,
                                    color: Colors.blueAccent.withValues(
                                      alpha: 0.8,
                                    ),
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Name and member since
                          Text(
                            'Dewashish Hatekar',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).brightness !=
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.white70,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Member since 2026',
                            style: !isdark
                                ? Theme.of(
                                    context,
                                  ).textTheme.titleSmall?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  )
                                : Theme.of(
                                    context,
                                  ).textTheme.titleSmall?.copyWith(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.bold,
                                  ),
                          ),
                          const SizedBox(height: 24),
                          // Events and Karma
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _InfoCard(title: 'EVENTS', value: '12'),
                              const SizedBox(width: 16),
                              _InfoCard(title: 'KARMA', value: '8.4k'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Account Info Title and Edit Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Account Info',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: controller.onEditProfile,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: !isdark
                                  ? Colors.black54
                                  : Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.2),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('Edit Profile'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Email
                    _AccountInfoCard(
                      icon: Icons.alternate_email,
                      label: 'EMAILADDRESS',
                      value: 'alex.sterling@fntech.com',
                      color: isdark
                          ? Theme.of(
                              context,
                            ).colorScheme.onSecondary.withValues(alpha: 0.4)
                          : Colors.purple.shade50,
                      onTap: controller.onEmailTap,
                    ),
                    // Phone
                    _AccountInfoCard(
                      icon: Icons.phone_android,
                      label: 'PHONENUMBER',
                      value: '+1 (555) 012-3456',
                      color: isdark
                          ? Theme.of(
                              context,
                            ).colorScheme.onSecondary.withValues(alpha: 0.4)
                          : Colors.green.shade50,
                      onTap: controller.onPhoneTap,
                    ),
                    // Home Address
                    _AccountInfoCard(
                      icon: Icons.home,
                      label: 'HOME ADDRESS',
                      value: 'Not Provided',
                      color: isdark
                          ? Theme.of(
                              context,
                            ).colorScheme.onSecondary.withValues(alpha: 0.4)
                          : Colors.orange.shade50,
                      onTap: controller.onAddressTap,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  const _InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 100,
      decoration: BoxDecoration(
        color: Brightness.dark == Theme.of(context).brightness
            ? Colors.black54
            : Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _AccountInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;
  const _AccountInfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withValues(alpha: .5),
              width: .55,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              // Glassmorphic icon background
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(icon, color: Colors.black87, size: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white60
                            : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black26,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
