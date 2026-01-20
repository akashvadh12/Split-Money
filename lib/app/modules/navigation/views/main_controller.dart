import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_money/app/modules/create_events/create_events.dart';
import 'package:split_money/app/modules/home/home_view.dart';
import 'package:split_money/app/modules/navigation/widgets/app_drawer.dart';
import 'package:split_money/app/modules/navigation/controllers/bottom_nav_controller.dart';
import 'package:split_money/app/modules/navigation/widgets/custom_bottom_nav_bar.dart';
import 'package:split_money/app/modules/Settings/settings_view.dart';

class MainScreen extends GetView<BottomNavController> {
  const MainScreen({super.key});

  static final List<Widget> _screens = [
    HomeScreen(),
    CreateEventScreen(),
    // StatsScreen(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.78,
        child: const Drawer(elevation: 8, child: AppDrawer()),
      ),
      extendBody: true,

      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: controller.onPageChanged,
        children: _screens,
      ),

      bottomNavigationBar: CustomBottomNavBar(
        controller: controller.notchBottomBarController,
        onTap: controller.changeTab,
        selectedIndex: controller.selectedIndex.value,
      ),
    );
  }
}
