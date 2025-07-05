import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _isNewUserKey = 'is_new_user';
  static const String _userTypeKey = 'user_type';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userIdKey = 'user_id';

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Check if user is new (first time user)
  static Future<bool> isNewUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isNewUserKey) ?? true;
  }

  // Get user type (client or photographer)
  static Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey);
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Get user name
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Get user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Sign in user
  static Future<bool> signIn({
    required String email,
    required String password,
    required String userType,
  }) async {
    try {
      final response = await SupabaseService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _saveUserData(
          isLoggedIn: true,
          isNewUser: false,
          userType: userType,
          email: email,
          name: response.user!.userMetadata?['name'] ?? '',
          userId: response.user!.id,
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Sign in error: $e');
      return false;
    }
  }

  // Sign up user
  static Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String userType,
  }) async {
    try {
      final response = await SupabaseService.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'user_type': userType,
        },
      );

      if (response.user != null) {
        await _saveUserData(
          isLoggedIn: true,
          isNewUser: false,
          userType: userType,
          email: email,
          name: name,
          userId: response.user!.id,
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Sign up error: $e');
      return false;
    }
  }

  // Sign out user
  static Future<void> signOut() async {
    try {
      await SupabaseService.signOut();
      await _clearUserData();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Mark user as not new (after onboarding)
  static Future<void> markUserAsNotNew() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isNewUserKey, false);
  }

  // Save user data to shared preferences
  static Future<void> _saveUserData({
    required bool isLoggedIn,
    required bool isNewUser,
    required String userType,
    required String email,
    required String name,
    required String userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
    await prefs.setBool(_isNewUserKey, isNewUser);
    await prefs.setString(_userTypeKey, userType);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userIdKey, userId);
  }

  // Clear user data from shared preferences
  static Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userTypeKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userIdKey);
    // Don't remove _isNewUserKey as it should persist
  }

  // Check if user is authenticated with Supabase
  static bool isAuthenticatedWithSupabase() {
    return SupabaseService.currentUser != null;
  }

  // Get current user from Supabase
  static User? getCurrentUser() {
    return SupabaseService.currentUser;
  }

  // Listen to auth state changes
  static Stream<AuthState> get authStateStream {
    return SupabaseService.authStateStream;
  }
} 