import 'dart:ui';
import 'package:flutter/material.dart';

class GlassSearchBar extends StatefulWidget {
  final String hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final Function()? onFilterTap;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final bool enabled;
  final bool showFilter;
  final bool showVoiceSearch;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;

  const GlassSearchBar({
    super.key,
    this.hintText = 'Search photographers, locations...',
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onFilterTap,
    this.onClear,
    this.controller,
    this.enabled = true,
    this.showFilter = true,
    this.showVoiceSearch = true,
    this.margin,
    this.height = 55,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
  });

  @override
  State<GlassSearchBar> createState() => _GlassSearchBarState();
}

class _GlassSearchBarState extends State<GlassSearchBar>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    _hasText = _controller.text.isNotEmpty;

    _setupAnimations();
    _setupListeners();
  }

  void _setupAnimations() {
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  void _setupListeners() {
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_isFocused) {
        _scaleController.forward();
      } else {
        _scaleController.reverse();
      }
    });

    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 20),
          height: widget.height,
          child: _buildSearchContainer(),
        ),
      ),
    );
  }

  Widget _buildSearchContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isFocused ? 0.15 : 0.08),
            blurRadius: _isFocused ? 25 : 15,
            offset: Offset(0, _isFocused ? 8 : 5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: widget.borderColor ??
                    (_isFocused
                        ? Colors.white.withOpacity(0.4)
                        : Colors.white.withOpacity(0.2)),
                width: _isFocused ? 2 : 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
            child: Row(
              children: [
                _buildSearchIcon(),
                _buildTextField(),
                if (_hasText) _buildClearButton(),
                if (widget.showVoiceSearch && !_hasText) _buildVoiceButton(),
                if (widget.showFilter) _buildFilterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchIcon() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 12),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        child: Icon(
          Icons.search,
          color: widget.iconColor ??
              (_isFocused
                  ? Colors.white
                  : Colors.white.withOpacity(0.7)),
          size: _isFocused ? 22 : 20,
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Expanded(
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        style: TextStyle(
          color: widget.textColor ?? Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: widget.hintColor ?? Colors.white.withOpacity(0.6),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
        cursorColor: Colors.white,
        cursorWidth: 2,
        cursorHeight: 20,
      ),
    );
  }

  Widget _buildClearButton() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: () {
          _controller.clear();
          if (widget.onClear != null) {
            widget.onClear!();
          }
        },
        child: Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            Icons.close,
            color: Colors.white.withOpacity(0.8),
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceButton() {
    return GestureDetector(
      onTap: () {
        // Handle voice search
        _showVoiceSearchDialog();
      },
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.mic,
          color: Colors.white.withOpacity(0.8),
          size: 18,
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: widget.onFilterTap,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.tune,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  void _showVoiceSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => _VoiceSearchDialog(),
    );
  }
}

class _VoiceSearchDialog extends StatefulWidget {
  @override
  _VoiceSearchDialogState createState() => _VoiceSearchDialogState();
}

class _VoiceSearchDialogState extends State<_VoiceSearchDialog>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isListening ? _pulseAnimation.value : 1.0,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.mic,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 24),
                Text(
                  _isListening ? 'Listening...' : 'Tap to start voice search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Try saying "photographers near me" or "wedding photographers"',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isListening = !_isListening;
                        });
                        if (_isListening) {
                          _pulseController.repeat(reverse: true);
                        } else {
                          _pulseController.stop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(_isListening ? 'Stop' : 'Start'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// // Usage Example
// class SearchExampleScreen extends StatefulWidget {
//   @override
//   _SearchExampleScreenState createState() => _SearchExampleScreenState();
// }
//
// class _SearchExampleScreenState extends State<SearchExampleScreen> {
//   final TextEditingController _searchController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Colors.purple.shade400,
//                   Colors.blue.shade600,
//                   Colors.teal.shade500,
//                 ],
//               ),
//             ),
//           ),
//
//           SafeArea(
//             child: Column(
//               children: [
//                 SizedBox(height: 20),
//
//                 // Search Bar
//                 GlassSearchBar(
//                   controller: _searchController,
//                   hintText: 'Search photographers, locations...',
//                   onChanged: (value) {
//                     print('Search changed: $value');
//                   },
//                   onSubmitted: (value) {
//                     print('Search submitted: $value');
//                   },
//                   onFilterTap: () {
//                     print('Filter tapped');
//                   },
//                   onClear: () {
//                     print('Search cleared');
//                   },
//                 ),
//
//                 SizedBox(height: 40),
//
//                 // Demo content
//                 Expanded(
//                   child: Center(
//                     child: Container(
//                       margin: EdgeInsets.all(20),
//                       padding: EdgeInsets.all(24),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.2),
//                           width: 1,
//                         ),
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.search,
//                             size: 48,
//                             color: Colors.white,
//                           ),
//                           SizedBox(height: 16),
//                           Text(
//                             'Glass Search Bar',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             'Beautiful glassmorphism search with animations',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.white.withOpacity(0.8),
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }