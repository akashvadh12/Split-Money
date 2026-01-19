import 'package:get/get.dart';
import 'package:split_money/app/modules/auth/auth_controller.dart';
import 'package:split_money/app/modules/auth/auth_register_view.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController());
  }
}
