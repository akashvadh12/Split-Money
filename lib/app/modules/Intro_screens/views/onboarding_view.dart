import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:split_money/app/modules/Intro_screens/controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: controller.skip,
                  child: const Text('Skip'),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.pages.length,
                itemBuilder: (context, index) {
                  final page = controller.pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image or Lottie
                        if (page.imageAsset != null)
                          Image.asset(page.imageAsset!, height: 150)
                        else if (page.lottieAsset != null)
                          Lottie.asset(
                            page.lottieAsset!,
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                        const SizedBox(height: 48),
                        // Title
                        Text(
                          page.title,
                          style: Theme.of(context).textTheme.displaySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // Description
                        Text(
                          page.description,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicator
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SmoothPageIndicator(
                controller: controller.pageController,
                count: controller.pages.length,
                effect: WormEffect(
                  dotColor: Theme.of(context).colorScheme.outline,
                  activeDotColor: Theme.of(context).colorScheme.primary,
                  dotHeight: 8,
                  dotWidth: 8,
                ),
              ),
            ),

            // Next/Get Started Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Obx(() {
                final buttonText =
                    controller.currentPage.value == controller.pages.length - 1
                    ? 'Get Started'
                    : 'Next';
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.next,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(buttonText),
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
