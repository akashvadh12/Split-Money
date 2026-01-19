import 'package:get/get.dart';
import 'package:split_money/app/modules/home/home_view.dart';
import 'package:split_money/main.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const HomeView(),
      // binding: SplashBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.onboarding,
    //   page: () => const OnboardingView(),
    //   binding: OnboardingBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.login,
    //   page: () => const LoginView(),
    //   binding: AuthBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.forgotPassword,
    //   page: () => const ForgotPasswordView(),
    //   binding: AuthBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.signup,
    //   page: () => const SignupView(),
    //   binding: AuthBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.location,
    //   page: () => const LocationView(),
    //   binding: LocationBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.main,
    //   page: () => const MainScreen(),
    //   binding: BottomNavBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.home,
    //   page: () => const HomeView(),
    //   binding: HomeBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.profile,
    //   page: () => const ProfileView(),
    //   binding: ProfileBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.editProfile,
    //   page: () => const EditProfileView(),
    //   binding: ProfileBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.changePassword,
    //   page: () => const ChangePasswordView(),
    //   binding: ProfileBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.aboutUs,
    //   page: () => const AboutUsView(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => CmsController());
    //   }),
    // ),
    // GetPage(
    //   name: AppRoutes.contactUs,
    //   page: () => const ContactUsView(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => CmsController());
    //   }),
    // ),
    // GetPage(
    //   name: AppRoutes.privacyPolicy,
    //   page: () => const PrivacyPolicyView(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => CmsController());
    //   }),
    // ),
    // GetPage(
    //   name: AppRoutes.terms,
    //   page: () => const TermsView(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => CmsController());
    //   }),
    // ),
  ];
}
