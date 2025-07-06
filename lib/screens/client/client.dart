import 'package:flutter/material.dart';
import 'package:photoconnect/screens/client/widget/bottom_bar.dart';
import 'home/home.dart';
import 'bookings/bookings_page.dart';
import 'favorites/favorites_page.dart';
import 'profile/profile_page.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundPattern(),
          _getCurrentPage(),

          // Glass Bottom Navigation Bar
          GlassBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: CustomPaint(painter: BackgroundPatternPainter()),
    );
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const BookingsPage();
      case 2:
        return const FavoritesPage();
      case 3:
        return const ProfilePage();
      default:
        return const HomePage();
    }
  }
}

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw geometric pattern
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 12; j++) {
        final x = (size.width / 8) * i;
        final y = (size.height / 12) * j;

        // Draw circles
        canvas.drawCircle(Offset(x, y), 20, paint);

        // Draw lines
        if (i < 7) {
          canvas.drawLine(
            Offset(x + 20, y),
            Offset(x + size.width / 8 - 20, y),
            paint,
          );
        }
      }
    }

    // Draw diagonal lines
    paint.color = Colors.black.withOpacity(0.03);
    for (int i = 0; i < 20; i++) {
      canvas.drawLine(
        Offset(i * 40.0, 0),
        Offset(i * 40.0 + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
