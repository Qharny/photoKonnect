import 'dart:ui';
import 'package:flutter/material.dart';
import 'hero_carousel.dart';
import 'search_section.dart';
import 'featured_photographers_section.dart';
import 'photographer_card.dart';
import 'all_photographers_section.dart';
import 'photographer_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _staggeredAnimation;
  late PageController _heroPageController;
  int _currentHeroPage = 0;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Sample photographer data
  final List<Map<String, dynamic>> _photographers = [
    {
      'name': 'Sarah Johnson',
      'specialty': 'Wedding Photography',
      'location': 'New York, NY',
      'rating': 4.9,
      'reviews': 127,
      'price': '\$200/hour',
      'image': 'assets/images/photographer1.jpg',
      'isAvailable': true,
      'featured': true,
    },
    {
      'name': 'Michael Chen',
      'specialty': 'Portrait Photography',
      'location': 'Los Angeles, CA',
      'rating': 4.8,
      'reviews': 89,
      'price': '\$150/hour',
      'image': 'assets/images/photographer2.jpg',
      'isAvailable': false,
      'featured': true,
    },
    {
      'name': 'Emma Rodriguez',
      'specialty': 'Event Photography',
      'location': 'Chicago, IL',
      'rating': 4.7,
      'reviews': 156,
      'price': '\$180/hour',
      'image': 'assets/images/photographer3.jpg',
      'isAvailable': true,
      'featured': false,
    },
    {
      'name': 'David Kim',
      'specialty': 'Fashion Photography',
      'location': 'Miami, FL',
      'rating': 4.9,
      'reviews': 203,
      'price': '\$250/hour',
      'image': 'assets/images/photographer4.jpg',
      'isAvailable': true,
      'featured': true,
    },
    {
      'name': 'Lisa Thompson',
      'specialty': 'Corporate Photography',
      'location': 'Seattle, WA',
      'rating': 4.6,
      'reviews': 78,
      'price': '\$120/hour',
      'image': 'assets/images/photographer5.jpg',
      'isAvailable': true,
      'featured': false,
    },
    {
      'name': 'Alex Morgan',
      'specialty': 'Nature Photography',
      'location': 'Denver, CO',
      'rating': 4.8,
      'reviews': 94,
      'price': '\$160/hour',
      'image': 'assets/images/photographer6.jpg',
      'isAvailable': true,
      'featured': true,
    },
  ];

  final List<Map<String, String>> _heroSlides = [
    {
      'image': 'assets/images/imageq.jpg',
      'title': 'Discover Amazing\nPhotographers',
      'subtitle': 'Find the perfect photographer for your special moments',
    },
    {
      'image': 'assets/images/Camera-amico.png',
      'title': 'Book Instantly',
      'subtitle': 'Seamless booking for any event or occasion',
    },
    {
      'image': 'assets/images/Moment.png',
      'title': 'Cherish Every Moment',
      'subtitle': 'Capture memories with top-rated professionals',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _heroPageController = PageController();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _staggeredAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    Future.delayed(Duration(milliseconds: 300), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _heroPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildGradientOverlay(),
          _buildMainContent(),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/imageq.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.95),
          ],
          stops: [0.0, 0.3, 0.6, 1.0],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildHeroSection(),
          _buildSearchSection(),
          _buildFeaturedPhotographersSection(),
          _buildAllPhotographersSection(),
          SliverToBoxAdapter(
            child: SizedBox(height: 100), // Bottom padding for nav bar
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icon/lens2.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'PhotoConnect',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => _showNotifications(),
                  ),
                ],
              ),
              SizedBox(height: 32),
              HeroCarousel(
                controller: _heroPageController,
                slides: _heroSlides,
                currentPage: _currentHeroPage,
                onPageChanged: (index) {
                  setState(() {
                    _currentHeroPage = index;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return SliverToBoxAdapter(
      child: SlideTransition(
        position: _slideAnimation,
        child: SearchSection(
          controller: _searchController,
          onChanged: _onSearchChanged,
          onFilterPressed: _showFilters,
          quickFilters: Row(
            children: [
              _buildQuickFilter('Location', Icons.location_on),
              SizedBox(width: 8),
              _buildQuickFilter('Specialty', Icons.category),
              SizedBox(width: 8),
              _buildQuickFilter('Available', Icons.access_time),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedPhotographersSection() {
    final featuredPhotographers = _photographers
        .where((p) => p['featured'] == true)
        .toList();
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _staggeredAnimation,
        child: FeaturedPhotographersSection(
          photographers: featuredPhotographers,
          onViewAll: _viewAllFeatured,
          photographerCardBuilder: (photographer) =>
              PhotographerCard(photographer: photographer),
        ),
      ),
    );
  }

  Widget _buildAllPhotographersSection() {
    return AllPhotographersSection(
      photographers: _photographers,
      listItemBuilder: (photographer) =>
          PhotographerListItem(photographer: photographer),
    );
  }

  Widget _buildQuickFilter(String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.7), size: 16),
            SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    // Implement search logic
    print('Search: $value');
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildFilterModal(),
    );
  }

  Widget _buildFilterModal() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Filter options would go here...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notifications opened'),
        backgroundColor: Colors.black.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewAllFeatured() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('View all featured photographers'),
        backgroundColor: Colors.black.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
