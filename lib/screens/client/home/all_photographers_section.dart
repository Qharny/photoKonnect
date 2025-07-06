import 'package:flutter/material.dart';

class AllPhotographersSection extends StatelessWidget {
  final List<Map<String, dynamic>> photographers;
  final Widget Function(Map<String, dynamic>) listItemBuilder;
  const AllPhotographersSection({
    super.key,
    required this.photographers,
    required this.listItemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'All Photographers',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            );
          }
          return listItemBuilder(photographers[index - 1]);
        }, childCount: photographers.length + 1),
      ),
    );
  }
}
