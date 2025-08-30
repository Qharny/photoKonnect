import 'package:flutter/material.dart';
import 'package:photoconnect/auth/auth_landing.dart';
import 'package:photoconnect/auth/login.dart';
import 'package:photoconnect/screens/client/auth/login.dart';
import 'package:photoconnect/screens/client/auth/signup.dart';
import 'package:photoconnect/screens/client/client.dart';
import 'package:photoconnect/screens/photographer/auth/login.dart';

import '../screens/onboarding/onboarding_screen.dart';
import '../screens/photographer/auth/signup.dart';

enum RouteAnimation {
  slideRight,
  slideLeft,
  slideUp,
  slideDown,
  fade,
  scale,
  rotation,
  none,
}

class RouteConfig {
  final String path;
  final WidgetBuilder builder;
  final RouteAnimation animation;
  final Duration duration;
  final bool requiresAuth;

  const RouteConfig({
    required this.path,
    required this.builder,
    this.animation = RouteAnimation.slideRight,
    this.duration = const Duration(milliseconds: 300),
    this.requiresAuth = false,
  });
}

class AppRoutes {
  static const String splash = '/splash';
  static const String onboard = '/onboard';
  static const String authland = '/authland';
  static const String photologin = '/photo-login';
  static const String login = '/login';
  static const String clientlogin = '/client-login';
  static const String photosignup = '/photo-signup';
  static const String clientsignup = '/client-signup';
  static const String home = '/home';
  static const String clienthome = '/client-home';
  static const String paymentAndBills = '/payment-and-bills';
  static const String results = '/results';
  static const String lecturerAssessment = '/lecturer-assessment';
  static const String notification = '/notification';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String mySettings = '/settings';

  // Route configurations with different animations
  static final Map<String, RouteConfig> _routeConfigs = {
    onboard: RouteConfig(
      path: onboard,
      builder: (context) => const OnboardingScreen(),
      animation: RouteAnimation.fade,
      duration: const Duration(milliseconds: 500),
    ),
    photologin: RouteConfig(
      path: photologin,
      builder: (context) => PhotographerLogin(),
      animation: RouteAnimation.slideRight,
      duration: const Duration(milliseconds: 400),
    ),
    login: RouteConfig(
      path: login,
      builder: (context) => LoginScreen(),
      animation: RouteAnimation.slideRight,
      duration: const Duration(milliseconds: 400),
    ),
    clientlogin: RouteConfig(
      path: clientlogin,
      builder: (context) => ClientLogin(),
      animation: RouteAnimation.slideRight,
      duration: const Duration(milliseconds: 400),
    ),
    authland: RouteConfig(
      path: authland,
      builder: (context) => const AuthLandingScreen(),
      animation: RouteAnimation.slideLeft,
      duration: const Duration(milliseconds: 400),
    ),
    photosignup: RouteConfig(
      path: photosignup,
      builder: (context) => const PhotoSignUp(),
      animation: RouteAnimation.scale,
      duration: const Duration(milliseconds: 350),
    ),
    clientsignup: RouteConfig(
      path: clientsignup,
      builder: (context) => const ClientSignUpScreen(),
      animation: RouteAnimation.slideUp,
      duration: const Duration(milliseconds: 350),
    ),
    home: RouteConfig(
      path: home,
      builder: (context) => const HomePage(),
      animation: RouteAnimation.slideRight,
    ),
    clienthome: RouteConfig(
      path: clienthome,
      builder: (context) => ClientHomePage(),
      animation: RouteAnimation.slideRight,
    ),
    paymentAndBills: RouteConfig(
      path: paymentAndBills,
      builder: (context) => const BillsPaymentsScreen(),
      animation: RouteAnimation.slideLeft,
    ),
    results: RouteConfig(
      path: results,
      builder: (context) => const ResultsScreen(),
      animation: RouteAnimation.scale,
    ),
    lecturerAssessment: RouteConfig(
      path: lecturerAssessment,
      builder: (context) => const LecturerAssessmentScreen(),
      animation: RouteAnimation.slideDown,
    ),
    notification: RouteConfig(
      path: notification,
      builder: (context) => const NotificationPage(),
      animation: RouteAnimation.slideUp,
    ),
    profile: RouteConfig(
      path: profile,
      builder: (context) => const ProfilePage(),
      animation: RouteAnimation.slideRight,
    ),
    editProfile: RouteConfig(
      path: editProfile,
      builder: (context) => const EditProfilePage(),
      animation: RouteAnimation.slideLeft,
    ),
    mySettings: RouteConfig(
      path: mySettings,
      builder: (context) => const SettingsPage(),
      animation: RouteAnimation.rotation,
    ),
  };

  static Map<String, WidgetBuilder> get routes {
    return Map.fromEntries(
      _routeConfigs.entries.map(
        (entry) => MapEntry(entry.key, entry.value.builder),
      ),
    );
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final routeConfig = _routeConfigs[settings.name];

    if (routeConfig == null) {
      return _createAnimatedRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Page Not Found')),
          body: Center(child: Image.asset("assets/gif/404.gif")),
        ),
        animation: RouteAnimation.fade,
        duration: const Duration(milliseconds: 300),
      );
    }

    Widget page = routeConfig.builder(
      settings.arguments as BuildContext? ??
          NavigationService.navigatorKey.currentContext!,
    );

    return _createAnimatedRoute(
      builder: (context) => page,
      animation: routeConfig.animation,
      duration: routeConfig.duration,
    );
  }

  static PageRoute _createAnimatedRoute({
    required WidgetBuilder builder,
    required RouteAnimation animation,
    required Duration duration,
  }) {
    switch (animation) {
      case RouteAnimation.slideRight:
        return SlideRoute(
          builder: builder,
          direction: SlideDirection.right,
          duration: duration,
        );
      case RouteAnimation.slideLeft:
        return SlideRoute(
          builder: builder,
          direction: SlideDirection.left,
          duration: duration,
        );
      case RouteAnimation.slideUp:
        return SlideRoute(
          builder: builder,
          direction: SlideDirection.up,
          duration: duration,
        );
      case RouteAnimation.slideDown:
        return SlideRoute(
          builder: builder,
          direction: SlideDirection.down,
          duration: duration,
        );
      case RouteAnimation.fade:
        return FadeRoute(builder: builder, duration: duration);
      case RouteAnimation.scale:
        return ScaleRoute(builder: builder, duration: duration);
      case RouteAnimation.rotation:
        return RotationRoute(builder: builder, duration: duration);
      case RouteAnimation.none:
        return MaterialPageRoute(builder: builder);
    }
  }
}

// Navigation Service for global navigation
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> navigateAndReplace(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  static void goBack() {
    return navigatorKey.currentState!.pop();
  }
}

// Custom Route Classes with Different Animations

enum SlideDirection { left, right, up, down }

class SlideRoute extends PageRouteBuilder {
  final WidgetBuilder builder;
  final SlideDirection direction;
  final Duration duration;

  SlideRoute({
    required this.builder,
    required this.direction,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) =>
             builder(context),
         transitionDuration: duration,
         reverseTransitionDuration: duration,
       );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    Offset begin;
    const Offset end = Offset.zero;

    switch (direction) {
      case SlideDirection.right:
        begin = const Offset(1.0, 0.0);
        break;
      case SlideDirection.left:
        begin = const Offset(-1.0, 0.0);
        break;
      case SlideDirection.up:
        begin = const Offset(0.0, 1.0);
        break;
      case SlideDirection.down:
        begin = const Offset(0.0, -1.0);
        break;
    }

    final tween = Tween(
      begin: begin,
      end: end,
    ).chain(CurveTween(curve: Curves.easeInOutCubic));

    return SlideTransition(position: animation.drive(tween), child: child);
  }
}

class FadeRoute extends PageRouteBuilder {
  final WidgetBuilder builder;
  final Duration duration;

  FadeRoute({
    required this.builder,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) =>
             builder(context),
         transitionDuration: duration,
         reverseTransitionDuration: duration,
       );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
      child: child,
    );
  }
}

class ScaleRoute extends PageRouteBuilder {
  final WidgetBuilder builder;
  final Duration duration;

  ScaleRoute({
    required this.builder,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) =>
             builder(context),
         transitionDuration: duration,
         reverseTransitionDuration: duration,
       );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: animation.drive(CurveTween(curve: Curves.elasticOut)),
      child: child,
    );
  }
}

class RotationRoute extends PageRouteBuilder {
  final WidgetBuilder builder;
  final Duration duration;

  RotationRoute({
    required this.builder,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) =>
             builder(context),
         transitionDuration: duration,
         reverseTransitionDuration: duration,
       );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RotationTransition(
      turns: animation.drive(
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
      ),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}

// Example usage in main.dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Routes Demo',
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Home Page')));
}

class BillsPaymentsScreen extends StatelessWidget {
  const BillsPaymentsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Bills Payments Screen')));
}

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Results Screen')));
}

class LecturerAssessmentScreen extends StatelessWidget {
  const LecturerAssessmentScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Lecturer Assessment Screen')));
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Notification Page')));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Profile'),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _showLogoutDialog(context),
        ),
      ],
    ),
    body: const Center(child: Text('Profile Page')),
  );

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(AppRoutes.authland);
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Edit Profile Page')));
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Settings options
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile'),
            onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () => Navigator.pushNamed(context, AppRoutes.notification),
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Payment & Bills'),
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.paymentAndBills),
          ),
          const Divider(),
          // Logout option
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    ),
  );

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(AppRoutes.authland);
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
