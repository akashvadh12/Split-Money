import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isdark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = !isdark
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.primary.withAlpha(50);
    final Color fieldColor = isdark ? Colors.white10 : Colors.white;
    final Color iconBgColor = isdark ? Colors.white10 : const Color(0xFFF9F6FF);
    final Color textColor = isdark ? Colors.white : Colors.black87;
    final Color labelColor = isdark ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isdark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: isdark ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Profile image with edit icon
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 52,
                        backgroundImage: NetworkImage(
                          controller.profileImage.value,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: controller.onEditProfileImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'FintechID: @${controller.fintechId.value}',
                style: TextStyle(
                  color: labelColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              // Full Name
              _EditProfileField(
                label: 'FULL NAME',
                icon: Icons.person,
                controller: controller.nameController,
                hintText: 'Full Name',
                fillColor: fieldColor,
                iconBgColor: iconBgColor,
                textColor: textColor,
                labelColor: labelColor,
              ),
              // Email
              _EditProfileField(
                label: 'EMAIL ADDRESS',
                icon: Icons.alternate_email,
                controller: controller.emailController,
                hintText: 'Email Address',
                fillColor: fieldColor,
                iconBgColor: iconBgColor,
                textColor: textColor,
                labelColor: labelColor,
              ),
              // Phone
              _EditProfileField(
                label: 'PHONE NUMBER',
                icon: Icons.phone,
                controller: controller.phoneController,
                hintText: 'Phone Number',
                fillColor: fieldColor,
                iconBgColor: iconBgColor,
                textColor: textColor,
                labelColor: labelColor,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.onSaveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isdark
                        ? Colors.black54
                        : Theme.of(context).colorScheme.primary.withAlpha(50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Save Changes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditProfileField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String hintText;
  final Color fillColor;
  final Color iconBgColor;
  final Color textColor;
  final Color labelColor;

  const _EditProfileField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.hintText,
    required this.fillColor,
    required this.iconBgColor,
    required this.textColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: textColor, size: 22),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: TextStyle(color: labelColor.withOpacity(0.7)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
