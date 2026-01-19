import 'package:get/get.dart';
import 'package:split_money/app/modules/auth/auth_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize AuthService as a singleton
    Get.put<AuthService>(AuthService(), permanent: true);
  }
}
