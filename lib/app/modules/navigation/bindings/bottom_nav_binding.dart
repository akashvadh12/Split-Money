import 'package:get/get.dart';
import 'package:split_money/app/modules/Settings/profile/profile_binding.dart';
import 'package:split_money/app/modules/navigation/controllers/bottom_nav_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize BottomNavController
    Get.lazyPut<BottomNavController>(() => BottomNavController());

    // Lazy load all tab bindings
    // HomeBinding().dependencies();
    // CategoriesBinding().dependencies();
    // OrdersBinding().dependencies();
    // ProfileBinding().dependencies();
  }
}
