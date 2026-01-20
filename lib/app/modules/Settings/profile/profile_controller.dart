import 'package:get/get.dart';

import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  // Observable fields for profile info
  RxString profileImage =
      'https://media.licdn.com/dms/image/v2/D4D03AQHLVGIVaL9i3A/profile-displayphoto-scale_200_200/B4DZlENDaYJYAc-/0/1757785898710?e=2147483647&v=beta&t=69OvRM_VA0P8Hb020ubfCOxTtJuKUUCNCeP5pYLBaY4'
          .obs;
  RxString fintechId = 'sarah_fn'.obs;
  TextEditingController nameController = TextEditingController(
    text: 'Sarah Jenkins',
  );
  TextEditingController emailController = TextEditingController(
    text: 'sarah.j@example.com',
  );
  TextEditingController phoneController = TextEditingController(
    text: '+1 (555) 000-1234',
  );

  // Called when edit profile button is tapped
  void onEditProfile() {
    Get.toNamed('/edit-profile');
  }

  // Called when camera icon is tapped
  void onEditProfileImage() {
    // TODO: Implement image picker logic
    // Example: Pick image and update profileImage.value
  }

  // Called when save changes is tapped
  void onSaveProfile() {
    // TODO: Implement save logic (API call, local update, etc.)
    // For now, just Get.back() to simulate save
    Get.back();
  }

  void onEmailTap() {
    // Handle email card tap
  }

  void onPhoneTap() {
    // Handle phone card tap
  }

  void onAddressTap() {
    // Handle address card tap
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
