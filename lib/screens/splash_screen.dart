import 'package:flutter/material.dart';
import '../routes/app_route.dart';
import '../services/auth_service.dart';
import '../utils/auth_utils.dart';

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
    await Future.delayed(const Duration(seconds: 4));

    // Debug: Print current auth state
    await AuthUtils.printAuthState();

    final isLoggedIn = await AuthService.isLoggedIn();
    final isNewUser = await AuthService.isNewUser();
    final userType = await AuthService.getUserType();

    if (mounted) {
      if (isNewUser) {
        Navigator.pushReplacementNamed(context, AppRoutes.onboard);
      } else if (isLoggedIn) {
        // Navigate based on user type
        if (userType == 'client') {
          Navigator.pushReplacementNamed(context, AppRoutes.clienthome);
        } else if (userType == 'photographer') {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.authland);
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
                SizedBox(child: Image.asset("assets/images/Feed.gif")),
                const SizedBox(height: 24),
                const Text(
                  'PhotoConnect',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
