import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photoconnect/routes/app_route.dart';
import 'package:photoconnect/screens/splash_screen.dart';

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
