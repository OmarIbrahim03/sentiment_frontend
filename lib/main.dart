// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/sentiment_tabs_page.dart';
import 'sentiment_tabs_page.dart';
import 'result_page.dart';
import 'features_page.dart';
import 'dart:math' as math;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media Analysis',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const ModernHomePage(),
        '/sentimentTabs': (context) => const SentimentTabsPage(),
        '/features': (context) => const FeaturesPage(), 
      },
    );
  }
}

class FloatingEmoji extends StatefulWidget {
  final String emoji;
  final double startX;
  final double startY;
  final Duration duration;
  final double endY;
  final VoidCallback? onComplete;

  const FloatingEmoji({
    super.key,
    required this.emoji,
    required this.startX,
    required this.startY,
    required this.duration,
    required this.endY,
    this.onComplete,
  });

  @override
  State<FloatingEmoji> createState() => _FloatingEmojiState();
}

class _FloatingEmojiState extends State<FloatingEmoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _positionAnimation = Tween<double>(
      begin: widget.startY,
      end: widget.endY,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.8,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: math.pi * 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
    ));

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.startX,
          top: _positionAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Text(
                  widget.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FloatingShape extends StatefulWidget {
  final Color color;
  final double size;
  final double startX;
  final double startY;
  final Duration duration;
  final VoidCallback? onComplete;

  const FloatingShape({
    super.key,
    required this.color,
    required this.size,
    required this.startX,
    required this.startY,
    required this.duration,
    this.onComplete,
  });

  @override
  State<FloatingShape> createState() => _FloatingShapeState();
}

class _FloatingShapeState extends State<FloatingShape>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _floatAnimation = Tween<double>(
      begin: 0,
      end: -300,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.6,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    ));

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.startX,
          top: widget.startY + _floatAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ModernHomePage extends StatefulWidget {
  const ModernHomePage({super.key});

  @override
  State<ModernHomePage> createState() => _ModernHomePageState();
}

class _ModernHomePageState extends State<ModernHomePage>
    with TickerProviderStateMixin {
  bool _isMenuOpen = false;
  bool _isDarkTheme = false;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  bool _hasTriggeredAutoScroll = false;
  bool _isAutoScrolling = false;

  // Simplified floating animations
  List<Widget> _floatingElements = [];
  Timer? _animationTimer;
  final List<String> _emojis = ['😀', '😢', '😡', '😍', '😐', '😂'];
  int _activeAnimations = 0;
  final int _maxAnimations = 2; // Reduced from 3 to 2

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Start floating animations after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startFloatingAnimation();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationTimer?.cancel();
    super.dispose();
  }

  void _startFloatingAnimation() {
    _animationTimer = Timer.periodic(const Duration(seconds: 4), (timer) { // Increased from 3 to 4 seconds
      if (mounted && _activeAnimations < _maxAnimations) {
        _addFloatingElement();
      }
    });
    
    // Add initial element
    if (mounted) {
      _addFloatingElement();
    }
  }

  void _addFloatingElement() {
    if (!mounted) return;
    
    final random = math.Random();
    final screenSize = MediaQuery.of(context).size;
    
    setState(() {
      _activeAnimations++;
      
      // Randomly choose between emoji and shape
      if (random.nextBool()) {
        _floatingElements.add(
          FloatingEmoji(
            key: UniqueKey(),
            emoji: _emojis[random.nextInt(_emojis.length)],
            startX: random.nextDouble() * (screenSize.width - 50),
            startY: screenSize.height + 50,
            endY: -100,
            duration: Duration(milliseconds: 5000 + random.nextInt(2000)), // Increased duration
            onComplete: _onAnimationComplete,
          ),
        );
      } else {
        _floatingElements.add(
          FloatingShape(
            key: UniqueKey(),
            color: Colors.white.withOpacity(0.08), // Reduced opacity
            size: 15 + random.nextDouble() * 15, // Reduced size
            startX: random.nextDouble() * (screenSize.width - 50),
            startY: screenSize.height + 50,
            duration: Duration(milliseconds: 6000 + random.nextInt(2000)), // Increased duration
            onComplete: _onAnimationComplete,
          ),
        );
      }
    });
  }

  void _onAnimationComplete() {
    if (mounted) {
      setState(() {
        _activeAnimations--;
        // Clean up completed animations
        _floatingElements.removeWhere((element) => 
          element.key != null && !mounted);
      });
    }
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });

    if (!_hasTriggeredAutoScroll && !_isAutoScrolling && _scrollOffset > 50) {
      _triggerAutoScroll();
    }
  }

  void _triggerAutoScroll() {
    _hasTriggeredAutoScroll = true;
    _isAutoScrolling = true;
    
    final double targetPosition = MediaQuery.of(context).size.height * 0.6;
    
    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    ).then((_) {
      _isAutoScrolling = false;
    });
  }

  double _getSlideOffset() {
    const double startSlideOffset = 100.0;
    const double completeSlideOffset = 300.0;
    
    if (_scrollOffset <= startSlideOffset) {
      return 1.0;
    } else if (_scrollOffset >= completeSlideOffset) {
      return 0.0;
    } else {
      return 1.0 - ((_scrollOffset - startSlideOffset) / (completeSlideOffset - startSlideOffset));
    }
  }

  double _getHeroSlideOffset() {
    const double startSlideOffset = 100.0;
    const double completeSlideOffset = 300.0;
    
    if (_scrollOffset <= startSlideOffset) {
      return 0.0;
    } else if (_scrollOffset >= completeSlideOffset) {
      return -1.0;
    } else {
      return -((_scrollOffset - startSlideOffset) / (completeSlideOffset - startSlideOffset));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkTheme 
          ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: const Color(0xFF1A1A2E),
            )
          : ThemeData.light(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isDarkTheme ? [
                const Color(0xFF1A1A2E),
                const Color(0xFF16213E),
                const Color(0xFF0F3460),
              ] : [
                const Color(0xFF6C63FF),
                const Color(0xFF9C27B0),
                const Color(0xFFF896B7),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Floating animations (reduced)
              ..._floatingElements,
              
              // Background decorative elements
              _buildBackgroundDecorations(),
              
              // Main content
              SafeArea(
                child: Column(
                  children: [
                    // Header with navigation
                    _buildHeader(),
                    
                    // Main scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: _isAutoScrolling 
                            ? const NeverScrollableScrollPhysics() 
                            : const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            ClipRect(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 2.8, // Reduced height
                                child: Stack(
                                  clipBehavior: Clip.hardEdge,
                                  children: [
                                    Transform.translate(
                                      offset: Offset(0, _getHeroSlideOffset() * MediaQuery.of(context).size.height * 0.6),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.6,
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            _buildHeroSection(),
                                            const SizedBox(height: 40),
                                            _buildAnalysisButtons(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                                    Transform.translate(
                                      offset: Offset(0, MediaQuery.of(context).size.height * 0.6 + (_getSlideOffset() * MediaQuery.of(context).size.height * 0.4)),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: _isDarkTheme ? const Color(0xFF16213E) : Colors.white,
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(24),
                                                topRight: Radius.circular(24),
                                              ),
                                            ),
                                            child: _buildFeaturesSection(),
                                          ),
                                          
                                          Container(
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                            child: _buildUseCasesSection(),
                                          ),
                                          
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: _isDarkTheme ? const Color(0xFF16213E) : Colors.white,
                                            ),
                                            child: _buildWhyChooseSection(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _buildFooter(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              if (_isMenuOpen) _buildSlidingMenu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.08), // Reduced opacity
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -80,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.06), // Reduced opacity
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 150,
          right: 30,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08), // Reduced opacity
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Social Media Analysis',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Theme toggle button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isDarkTheme = !_isDarkTheme;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _isDarkTheme ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Menu button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isMenuOpen = !_isMenuOpen;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Social Media Analyser',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            const Text('📊', style: TextStyle(fontSize: 20)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Flexible(
              child: Text(
                'Use analysis to quickly detect\nfeelings and pain points.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          ],
        ),
      ],
    );
  }

  Widget _buildAnalysisButtons() {
  return Row(
    children: [
      Expanded(
        child: _buildAnalysisButton(
          'Text Analysis 📝',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SentimentTabsPage(initialTab: 0),
              ),
            );
          },
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: _buildAnalysisButton(
          'Post Url Analysis 🔗',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SentimentTabsPage(initialTab: 1),
              ),
            );
          },
        ),
      ),
    ],
  );
}

  Widget _buildAnalysisButton(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Row(
            children: [
              Flexible(
                child: Text(
                  'How can sentiment\nanalysis help you',
                  style: TextStyle(
                    color: _isDarkTheme ? Colors.white : const Color(0xFF7B68EE),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildFeatureItem(
            'Learn the topics your clients are most happy or unhappy about.',
          ),
          const SizedBox(height: 24),
          _buildFeatureItem(
            'Identify pain-points and detect patterns in client needs and behavior',
          ),
          const SizedBox(height: 24),
          _buildFeatureItem(
            'Quickly detect negative feedback and take action instantly.',
          ),
          const SizedBox(height: 24),
          _buildFeatureItem(
            'Monitor brand reputation and track sentiment trends over time.',
          ),
          const SizedBox(height: 24),
          _buildFeatureItem(
            'Automate response prioritization based on sentiment urgency levels.',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildUseCasesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Flexible(
                child: Text(
                  'Use Cases For Our Solution\nWho Benefits ?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          _buildFeatureCard(
            'E-commerce 🛒',
            'Analyze product reviews to improve\nsales.',
            const Color(0xFF440072),
          ),
          const SizedBox(height: 20),
          _buildFeatureCard(
            'Social Media Managers 📱',
            'Track brand sentiment across\nplatforms.',
            const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 20),
          _buildFeatureCard(
            'Security 🔒',
            'Detect inappropriate content\nautomatically.',
            const Color(0xFFA34608),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildWhyChooseSection() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(32),
    decoration: const BoxDecoration(
    color: Colors.transparent, 
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        
        Text(
          'Why Choose Our Platform?',
          style: TextStyle(
            color: _isDarkTheme ? Colors.white: Colors.black, // Changed to white for better visibility on transparent background
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        _buildDetailedFeatureItem(
          Icons.speed,
          'Fast & Accurate',
          'Get precise sentiment analysis results in seconds, not minutes.',
        ),
        const SizedBox(height: 20),
        _buildDetailedFeatureItem(
          Icons.security,
          'Secure & Private',
          'Your data is processed securely and never stored on our servers.',
        ),
        const SizedBox(height: 20),
        _buildDetailedFeatureItem(
          Icons.trending_up,
          'Advanced Analytics',
          'Get detailed insights with confidence scores and emotion breakdowns.',
        ),
        const SizedBox(height: 20),
        _buildDetailedFeatureItem(
          Icons.support_agent,
          '24/7 Support',
          'Our team is always ready to help you make the most of our platform.',
        ),
        const SizedBox(height: 24),
      ],
    ),
  );
}

  Widget _buildDetailedFeatureItem(IconData icon, String title, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkTheme ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF7B68EE).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF7B68EE),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _isDarkTheme ? Colors.white : Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: _isDarkTheme ? Colors.white70 : Colors.black54,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Icon(
            Icons.check,
            color: _isDarkTheme ? Colors.white : const Color(0xFF7B68EE),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: _isDarkTheme ? Colors.white70 : Colors.black87,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String title, String description, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.8),
            color.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: _isDarkTheme ? const Color(0xFF16213E) : const Color(0xFFE8E3FF),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('📞', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Text(
                'Contact us',
                style: TextStyle(
                  color: _isDarkTheme ? Colors.white : Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(
                'assets/icons/twitter.png', 
                'Twitter', 
                const Color(0xDD000000),
                'https://twitter.com'
              ),
              const SizedBox(width: 20),
              _buildSocialIcon(
                'assets/icons/facebook.png', 
                'Facebook', 
                const Color(0xFF1877F2),
                'https://facebook.com'
              ),
              const SizedBox(width: 20),
              _buildSocialIcon(
                'assets/icons/instagram.png',
                'Instagram', 
                Colors.black87,
                'https://instagram.com'
              ),
              const SizedBox(width: 20),
              _buildSocialIcon(
                'assets/icons/telegram.png', 
                'Telegram', 
                Colors.black87,
                'https://telegram.org'
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            height: 1,
            width: double.infinity,
            color: _isDarkTheme ? Colors.white24 : Colors.black12,
          ),
          const SizedBox(height: 20),
          Text(
            'Copyright © 2025. Social Media Analysis. All rights reserved',
            style: TextStyle(
              color: _isDarkTheme ? Colors.white54 : Colors.black54,
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(String iconPath, String platform, Color color, String url) {
    return GestureDetector(
      onTap: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening $platform...'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: Colors.white,
            errorBuilder: (context, error, stackTrace) {
              return _getFallbackIcon(platform);
            },
          ),
        ),
      ),
    );
  }

  Widget _getFallbackIcon(String platform) {
    IconData fallbackIcon;
    switch (platform.toLowerCase()) {
      case 'twitter':
        fallbackIcon = Icons.close; // X icon for Twitter/X
        break;
      case 'facebook':
        fallbackIcon = Icons.facebook;
        break;
      case 'instagram':
        fallbackIcon = Icons.camera_alt;
        break;
      case 'telegram':
        fallbackIcon = Icons.send;
        break;
      default:
        fallbackIcon = Icons.link;
    }
    
    return Icon(
      fallbackIcon,
      color: Colors.white,
      size: 24,
    );
  }

  Widget _buildSlidingMenu() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isMenuOpen = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 250,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Menu',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isMenuOpen = false;
                            });
          },
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  _buildMenuItem('Home', () {
                    setState(() {
                      _isMenuOpen = false;
                    });
                  }),
                  _buildMenuItem('Features', () {
                    Navigator.pushNamed(context, '/features');
                    setState(() {
                      _isMenuOpen = false;
                    });
                  }),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sentimentTabs');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Start Analysis'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}