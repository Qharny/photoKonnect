import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_color.dart';
import '../widgets/custom_button.dart';
import '../routes/custom_page_route.dart';
import 'auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Find Professional Photographers',
      description: 'Discover talented photographers in your area for any occasion.',
      animationUrl: 'https://lottie.host/embed/4c872e33-5b33-4a6c-9c7d-a5f5e5f5e5f5/4c872e33-5b33-4a6c-9c7d-a5f5e5f5e5f5.json', // Camera animation
      icon: Icons.camera_alt,
    ),
    OnboardingData(
      title: 'Book & Schedule Sessions',
      description: 'Easy booking system with real-time availability and instant confirmation.',
      animationUrl: 'https://lottie.host/embed/calendar-animation.json',
      icon: Icons.calendar_today,
    ),
    OnboardingData(
      title: 'Secure Payments & Reviews',
      description: 'Safe payment processing and authentic reviews from real clients.',
      animationUrl: 'https://lottie.host/embed/payment-animation.json',
      icon: Icons.payment,
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        CustomPageRoute(
          child: const LoginScreen(),
          transitionsBuilder: CustomPageRoute.slideFromRight,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 60),
                  Text(
                    'PhotoConnect',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _pages[index]);
                },
              ),
            ),

            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: CustomButton(
                        text: 'Previous',
                        isOutlined: true,
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                      onPressed: () {
                        if (_currentPage == _pages.length - 1) {
                          _completeOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String animationUrl;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.animationUrl,
    required this.icon,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animation container with fallback
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: AppColors.softSkyBlue,
              borderRadius: BorderRadius.circular(150),
            ),
            child: Center(
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  data.icon,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 60),

          Text(
            data.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          Text(
            data.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}