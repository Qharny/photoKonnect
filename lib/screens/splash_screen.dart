import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_route.dart';
import '../theme/app_color.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

 Future<void> _checkAuthAndNavigate() async {
   await Future.delayed(const Duration(seconds: 5));

   final prefs = await SharedPreferences.getInstance();
   final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
   final isNewUser = prefs.getBool('is_new_user') ?? true;

   if (mounted) {
     if (isNewUser) {
       Navigator.pushReplacementNamed(context, AppRoutes.onboard);
     } else if (isLoggedIn) {
       Navigator.pushReplacementNamed(context, AppRoutes.home);
     } else {
       Navigator.pushReplacementNamed(context, AppRoutes.login);
     }
   }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Center content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  child: Image.asset("assets/images/Feed.gif"),
                ),
                const SizedBox(height: 24),
                const Text(
                  'PhotoConnect',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
              ],
            ),
          ),
          // Bottom copyright text
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Text(
              "© 2025 PhotoConnect. All rights reserved.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ),
        ],
      ),
    );
  }
}
