import 'dart:ui';
import 'package:flutter/material.dart';

class FeaturedPhotographersSection extends StatelessWidget {
  final List<Map<String, dynamic>> photographers;
  final VoidCallback onViewAll;
  final Widget Function(Map<String, dynamic>) photographerCardBuilder;
  const FeaturedPhotographersSection({
    super.key,
    required this.photographers,
    required this.onViewAll,
    required this.photographerCardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Photographers',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 24),
              itemCount: photographers.length,
              itemBuilder: (context, index) {
                return photographerCardBuilder(photographers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
