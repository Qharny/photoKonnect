import 'package:flutter/material.dart';

class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final RouteTransitionsBuilder transitionsBuilder;

  CustomPageRoute({
    required this.child,
    required this.transitionsBuilder,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: transitionsBuilder,
    transitionDuration: const Duration(milliseconds: 500),
  );

  // Slide transition from right
  static RouteTransitionsBuilder slideFromRight = (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: child,
    );
  };

  // Fade transition
  static RouteTransitionsBuilder fadeTransition = (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  };

  // Scale transition
  static RouteTransitionsBuilder scaleTransition = (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.elasticOut,
      )),
      child: child,
    );
  };
}
