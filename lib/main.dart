import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photoconnect/routes/app_route.dart';
import 'package:photoconnect/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

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
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        ...AppRoutes.routes,
      },
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
