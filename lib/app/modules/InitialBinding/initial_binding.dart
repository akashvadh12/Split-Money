import 'package:get/get.dart';
import 'package:split_money/app/modules/auth/auth_service.dart';
import 'package:split_money/app/core/services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ NO async code here
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<StorageService>(StorageService(), permanent: true);
  }
}
