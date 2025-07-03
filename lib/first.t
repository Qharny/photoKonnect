import 'package:flutter/material.dart';
import 'package:photoconnect/screens/auth/login_screen.dart';
import 'package:photoconnect/screens/home_screen.dart';
import 'package:photoconnect/screens/onboarding_screen.dart';
import 'package:photoconnect/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();

await Supabase.initialize(
url: 'https://xkdzovdfdhgagormwwoz.supabase.co',
anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhrZHpvdmRmZGhnYWdvcm13d296Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU3Nzc3NjcsImV4cCI6MjA2MTM1Mzc2N30.konG1gv3rsNHD_jJ64qfaWEwezFLAlNjW3iRZvlg_Gc'
);

runApp(const PhotoConnect());
}

class PhotoConnect extends StatelessWidget {
const PhotoConnect({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'PhotoConnect',
debugShowCheckedModeBanner: false,
theme: AppTheme.lightTheme.copyWith(
textTheme: GoogleFonts.interTextTheme(AppTheme.lightTheme.textTheme),
),
darkTheme: AppTheme.darkTheme.copyWith(
textTheme: GoogleFonts.interTextTheme(AppTheme.darkTheme.textTheme),
),
themeMode: ThemeMode.system,
home: const SplashScreen(),
routes: {
'/onboarding': (context) => const OnboardingScreen(),
'/login': (context) => const LoginScreen(),
'/home': (context) => const HomeScreen(),
},
);
}
}

