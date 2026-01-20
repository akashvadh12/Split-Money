import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;
    final hintColor = theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          children: [
            // ================= PROFILE AVATAR =================
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 58,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Obx(
                      () => CircleAvatar(
                        radius: 54,
                        backgroundImage: NetworkImage(
                          controller.profileImage.value,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: isDark
                        ? theme.colorScheme.primary.withValues(alpha: 0.8)
                        : theme.colorScheme.primary.withValues(alpha: 0.8),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: controller.onEditProfileImage,
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ================= FORM CARD =================
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              decoration: BoxDecoration(
                color: isDark
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2)
                    : Colors.black87,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _ProfileField(
                    label: 'Full Name',
                    icon: Icons.person_outline_rounded,
                    controller: controller.nameController,
                    hintText: 'Enter your name',
                    textColor: textColor,
                    hintColor: hintColor,
                  ),
                  const SizedBox(height: 18),
                  _ProfileField(
                    label: 'Email Address',
                    icon: Icons.alternate_email_rounded,
                    controller: controller.emailController,
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    textColor: textColor,
                    hintColor: hintColor,
                  ),
                  const SizedBox(height: 18),
                  _ProfileField(
                    label: 'Phone Number',
                    icon: Icons.phone_rounded,
                    controller: controller.phoneController,
                    hintText: 'Enter your phone',
                    keyboardType: TextInputType.phone,
                    textColor: textColor,
                    hintColor: hintColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ================= SAVE BUTTON =================
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: controller.onSaveProfile,
                icon: const Icon(Icons.check_rounded),
                label: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
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

// =======================================================================
// FIELD WIDGET
// =======================================================================

class _ProfileField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final Color textColor;
  final Color hintColor;

  const _ProfileField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.hintText,
    required this.textColor,
    required this.hintColor,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: Brightness.dark == theme.brightness
                ? Colors.white70
                : Colors.grey.shade100,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Brightness.dark == theme.brightness
                ? Colors.black45
                : Colors.white70,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
