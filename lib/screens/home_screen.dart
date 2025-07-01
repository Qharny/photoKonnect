import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/custom_button.dart';
import '../../services/supabase_service.dart';
import '../../utils/custom_page_route.dart';
import '../models/photograher.dart';
import '../theme/app_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const HomeTab(),
    // const BookingsScreen(),
    // const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Photographer> _photographers = [];
  List<Photographer> _filteredPhotographers = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Wedding',
    'Portrait',
    'Event',
    'Corporate',
    'Fashion',
    'Nature'
  ];

  @override
  void initState() {
    super.initState();
    _loadPhotographers();
    _searchController.addListener(_filterPhotographers);
  }

  Future<void> _loadPhotographers() async {
    try {
      final data = await SupabaseService.getPhotographers();
      final photographers = data.map((json) => Photographer.fromJson(json)).toList();

      setState(() {
        _photographers = photographers;
        _filteredPhotographers = photographers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load photographers: ${e.toString()}'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  void _filterPhotographers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPhotographers = _photographers.where((photographer) {
        final matchesSearch = photographer.name.toLowerCase().contains(query) ||
            photographer.location.toLowerCase().contains(query);

        final matchesCategory = _selectedCategory == 'All' ||
            photographer.specialties.any((specialty) =>
                specialty.toLowerCase().contains(_selectedCategory.toLowerCase()));

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = SupabaseService.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${user?.userMetadata?['name'] ?? 'User'}!',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Find your perfect photographer',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Search bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search photographers or location...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {
                          // TODO: Show filter modal
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                ],
              ),
            ),

            // Categories
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                      _filterPhotographers();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Photographers list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredPhotographers.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No photographers found',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Try adjusting your search or filters',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filteredPhotographers.length,
                itemBuilder: (context, index) {
                  final photographer = _filteredPhotographers[index];
                  return PhotographerCard(photographer: photographer);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class PhotographerCard extends StatelessWidget {
  final Photographer photographer;

  const PhotographerCard({super.key, required this.photographer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: InkWell(
        onTap: () {
          // Navigator.of(context).push(
          //   CustomPageRoute(
          //     child: PhotographerDetailScreen(photographer: photographer),
          //     transitionsBuilder: CustomPageRoute.slideFromRight,
          //   ),
          // );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Profile image
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: photographer.profileImage != null
                        ? CachedNetworkImageProvider(photographer.profileImage!)
                        : null,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: photographer.profileImage == null
                        ? const Icon(Icons.person, color: Colors.white, size: 30)
                        : null,
                  ),

                  const SizedBox(width: 16),

                  // Photographer info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          photographer.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              photographer.location,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${photographer.rating.toStringAsFixed(1)} (${photographer.reviewCount} reviews)',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Availability indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: photographer.isAvailable
                          ? AppColors.successGreen
                          : AppColors.errorRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      photographer.isAvailable ? 'Available' : 'Busy',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Specialties
              if (photographer.specialties.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: photographer.specialties.take(3).map((specialty) {
                    return Chip(
                      label: Text(
                        specialty,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: AppColors.softSkyBlue,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),

              const SizedBox(height: 12),

              // Price and book button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${photographer.hourlyRate.toStringAsFixed(0)}/hour',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  CustomButton(
                    text: 'View Profile',
                    width: 120,
                    height: 36,
                    onPressed: () {
                      // Navigator.of(context).push(
                      //   CustomPageRoute(
                      //     child: PhotographerDetailScreen(photographer: photographer),
                      //     transitionsBuilder: CustomPageRoute.slideFromRight,
                      //   ),
                      // );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}