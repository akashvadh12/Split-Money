// ==================== AUTH SERVICE ====================
// File: lib/services/auth_service.dart

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  final Rx<bool> isAuthenticated = false.obs;
  final Rx<String?> currentUserEmail = Rx<String?>(null);

  // Mock credentials
  static const String mockEmail = 'Test@gmail.com';
  static const String mockPassword = 'Test1234';

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final email = prefs.getString('userEmail');

    if (isLoggedIn && email != null) {
      isAuthenticated.value = true;
      currentUserEmail.value = email;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation
      if (email.toLowerCase() == mockEmail.toLowerCase() && 
          password == mockPassword) {
        
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', email);

        isAuthenticated.value = true;
        currentUserEmail.value = email;

        return {
          'success': true,
          'message': 'Login successful',
          'user': {
            'email': email,
            'name': 'Test User',
          }
        };
      } else {
        return {
          'success': false,
          'message': 'Invalid email or password',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred. Please try again.',
      };
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    isAuthenticated.value = false;
    currentUserEmail.value = null;
  }

  bool get isLoggedIn => isAuthenticated.value;
}
