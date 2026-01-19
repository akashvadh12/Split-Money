import 'package:get/get.dart';
import 'package:split_money/app/modules/auth/auth_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
