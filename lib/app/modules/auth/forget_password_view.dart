import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/modules/auth/auth_controller.dart';

// Controller is centralized in `auth_controller.dart` (use LoginController.fp* members).

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: const Text('Forgot Password'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                'Recover your account using email or mobile',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Mode toggle
              Obx(() {
                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.fpSetModeEmail,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: controller.fpUseEmail.value
                              ? Theme.of(context).primaryColor
                              : null,
                          foregroundColor: controller.fpUseEmail.value
                              ? Colors.white
                              : null,
                        ),
                        child: const Text('Use Email'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.fpSetModeMobile,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: controller.fpUseEmail.value
                              ? null
                              : Theme.of(context).primaryColor,
                          foregroundColor: controller.fpUseEmail.value
                              ? null
                              : Colors.white,
                        ),
                        child: const Text('Use Mobile'),
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 16),

              // Contact input
              Obx(() {
                return controller.fpUseEmail.value
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: controller.fpEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              errorText: controller.fpEmailError.value.isEmpty
                                  ? null
                                  : controller.fpEmailError.value,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: controller.fpMobileController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Mobile number',
                              errorText: controller.fpMobileError.value.isEmpty
                                  ? null
                                  : controller.fpMobileError.value,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
              }),

              // Send OTP / Next button
              Obx(
                () => ElevatedButton(
                  onPressed: controller.fpIsLoading.value
                      ? null
                      : controller.fpSendOtp,
                  child: controller.fpIsLoading.value
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Next'),
                ),
              ),

              const SizedBox(height: 16),

              // Animated OTP area
              Obx(() {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: controller.fpShowOtp.value
                      ? Column(
                          key: const ValueKey('otp_visible'),
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: controller.fpOtpController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Enter OTP',
                                errorText: controller.fpOtpError.value.isEmpty
                                    ? null
                                    : controller.fpOtpError.value,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: controller.fpIsLoading.value
                                  ? null
                                  : controller.fpVerifyOtp,
                              child: controller.fpIsLoading.value
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Submit OTP'),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                controller.fpShowOtp.value = false;
                                controller.fpOtpController.clear();
                              },
                              child: const Text('Back'),
                            ),
                          ],
                        )
                      : const SizedBox(key: ValueKey('otp_hidden')),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
