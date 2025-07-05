import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthUtils {
  // Debug method to print current auth state
  static Future<void> printAuthState() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    final isNewUser = await AuthService.isNewUser();
    final userType = await AuthService.getUserType();
    final userEmail = await AuthService.getUserEmail();
    final userName = await AuthService.getUserName();
    final userId = await AuthService.getUserId();

    print('=== Auth State Debug ===');
    print('Is Logged In: $isLoggedIn');
    print('Is New User: $isNewUser');
    print('User Type: $userType');
    print('User Email: $userEmail');
    print('User Name: $userName');
    print('User ID: $userId');
    print('=======================');
  }

  // Clear all auth data (for testing)
  static Future<void> clearAllAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('All auth data cleared');
  }

  // Check if user should see onboarding
  static Future<bool> shouldShowOnboarding() async {
    return await AuthService.isNewUser();
  }

  // Check if user should be redirected to login
  static Future<bool> shouldRedirectToLogin() async {
    return !(await AuthService.isLoggedIn());
  }

  // Get appropriate home route based on user type
  static Future<String> getHomeRoute() async {
    final userType = await AuthService.getUserType();
    if (userType == 'client') {
      return '/client-home';
    } else if (userType == 'photographer') {
      return '/home';
    } else {
      return '/home'; // Default fallback
    }
  }
}
