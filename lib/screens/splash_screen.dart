import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/animated_logo.dart';
import '../services/supabase_service.dart';
import '../utils/custom_page_route.dart';
import 'auth/login_screen.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
    final user = SupabaseService.currentUser;

    if (!mounted) return;

    if (!hasSeenOnboarding) {
      Navigator.of(context).pushReplacement(
        CustomPageRoute(
          child: const OnboardingScreen(),
          transitionsBuilder: CustomPageRoute.fadeTransition,
        ),
      );
    } else if (user != null) {
      Navigator.of(context).pushReplacement(
        CustomPageRoute(
          child: const HomeScreen(),
          transitionsBuilder: CustomPageRoute.fadeTransition,
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        CustomPageRoute(
          child: const LoginScreen(),
          transitionsBuilder: CustomPageRoute.fadeTransition,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedLogo(size: 120),
              SizedBox(height: 30),
              Text(
                'PhotoConnect',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Connect with Professional Photographers',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
