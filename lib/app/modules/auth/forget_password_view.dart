import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/modules/auth/auth_controller.dart';
import 'package:flutter/services.dart';

// Controller is centralized in `auth_controller.dart` (use LoginController.fp* members).

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Clear all fields and errors
            controller.fpEmailController.clear();
            controller.fpMobileController.clear();
            controller.fpEmailError.value = '';
            controller.fpMobileError.value = '';
            controller.fpOtpError.value = '';
            for (final c in controller.fpOtpControllers) {
              c.clear();
            }
            for (final f in controller.fpOtpFocusNodes) {
              f.unfocus();
            }
            controller.fpShowOtp.value = false;
            Get.back();
          },
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
                        onPressed: () => controller.fpSetModeEmail(),
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
                        onPressed: () => controller.fpSetModeMobile(),
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
                            focusNode: controller.fpEmailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Enter your Email',
                              hintStyle: TextStyle(
                                color: isDark
                                    ? const Color(0xFF8A9291)
                                    : const Color(0xFF707978),
                              ),
                              suffixIcon: Icon(
                                Icons.alternate_email,
                                color: isDark
                                    ? const Color(0xFF8A9291)
                                    : const Color(0xFF707978),
                              ),
                              filled: true,
                              fillColor: isDark
                                  ? const Color(0xFF222427)
                                  : Theme.of(
                                      context,
                                    ).colorScheme.primary.withValues(alpha: .1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              errorText: controller.fpEmailError.value.isEmpty
                                  ? null
                                  : controller.fpEmailError.value,
                              contentPadding: const EdgeInsets.all(20),
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
                            focusNode: controller.fpMobileFocusNode,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              hintText: 'Enter your mobile',
                              hintStyle: TextStyle(
                                color: isDark
                                    ? const Color(0xFF8A9291)
                                    : const Color(0xFF707978),
                              ),
                              suffixIcon: Icon(
                                Icons.phone_android,
                                color: isDark
                                    ? const Color(0xFF8A9291)
                                    : const Color(0xFF707978),
                              ),
                              filled: true,
                              fillColor: isDark
                                  ? const Color(0xFF222427)
                                  : Theme.of(
                                      context,
                                    ).colorScheme.primary.withValues(alpha: .1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              errorText: controller.fpMobileError.value.isEmpty
                                  ? null
                                  : controller.fpMobileError.value,
                              contentPadding: const EdgeInsets.all(20),
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
                            const SizedBox(height: 12),
                            Text(
                              controller.fpUseEmail.value
                                  ? 'Enter the OTP sent to your email'
                                  : 'Enter the OTP sent to your mobile',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),

                            // OTP fields
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(6, (i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0,
                                  ),
                                  child: SizedBox(
                                    width: 48,
                                    child: TextField(
                                      controller:
                                          controller.fpOtpControllers[i],
                                      focusNode: controller.fpOtpFocusNodes[i],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(1),
                                      ],
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(
                                          14,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onChanged: (v) {
                                        if (v.length == 1) {
                                          if (i + 1 <
                                              controller
                                                  .fpOtpFocusNodes
                                                  .length) {
                                            controller.fpOtpFocusNodes[i + 1]
                                                .requestFocus();
                                          } else {
                                            controller.fpOtpFocusNodes[i]
                                                .unfocus();
                                          }
                                        } else if (v.isEmpty && i - 1 >= 0) {
                                          controller.fpOtpFocusNodes[i - 1]
                                              .requestFocus();
                                        }

                                        if (controller
                                            .fpOtpError
                                            .value
                                            .isNotEmpty) {
                                          controller.fpOtpError.value = '';
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }),
                            ),

                            if (controller.fpOtpError.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                  vertical: 12,
                                ),
                                child: Text(
                                  controller.fpOtpError.value,
                                  style: const TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                            const SizedBox(height: 16),


                            // Only show Submit OTP if OTP area is visible
                            if (controller.fpShowOtp.value)
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

                            TextButton(
                              onPressed: () {
                                controller.fpShowOtp.value = false;
                                for (final c in controller.fpOtpControllers) {
                                  c.clear();
                                }
                                for (final f in controller.fpOtpFocusNodes) {
                                  f.unfocus();
                                }
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
