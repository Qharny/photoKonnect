import 'package:flutter/material.dart';
import 'package:photoconnect/screens/client/widget/bottom_bar.dart';

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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 48,
                        color: Colors.white,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'PhotoConnect',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Current Tab: ${_getCurrentTabName()}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

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
      child: CustomPaint(
        painter: BackgroundPatternPainter(),
      ),
    );
  }



  String _getCurrentTabName() {
    switch (_currentIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Bookings';
      case 2:
        return 'Favorites';
      case 3:
        return 'Profile';
      default:
        return 'Home';
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
        canvas.drawCircle(
          Offset(x, y),
          20,
          paint,
        );

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