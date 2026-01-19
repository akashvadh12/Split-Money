import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/core/theme/theme.dart';
import 'package:split_money/app/modules/InitialBinding/initial_binding.dart';
import 'package:split_money/app/routes/app_pages.dart';
import 'package:split_money/app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SplitMoney());
}
class SplitMoney extends StatelessWidget {
  const SplitMoney({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Split Money',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
       initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    
      // initialRoute: AppRoutes.splash,
      defaultTransition: Transition.cupertino,
    );
  }
}
