import 'package:flutter/material.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6C63FF),
              Color(0xFF9C27B0),
              Color.fromARGB(255, 248, 150, 183),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              _buildHeader(context),
              
              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero section
                      _buildHeroSection(),
                      const SizedBox(height: 40),
                      
                      // Features grid
                      _buildFeaturesGrid(),
                      const SizedBox(height: 40),
                      
                      // Detailed features
                      _buildDetailedFeatures(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Features',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Powerful Features for\nSocial Media Analysis',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Discover how our advanced sentiment analysis\ncan transform your social media strategy.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesGrid() {
    return Column(
      children: [
        _buildFeatureCard(
          '1',
          'Social Media Sentiment Analysis',
          'Analyze the emotional tone behind posts or comments\non:',
          [
            'Facebook',
            'X (formerly Twitter)',
            'TikTok'
          ],
          Icons.analytics,
          const Offset(-50, 0),
        ),
        const SizedBox(height: 20),
        _buildFeatureCard(
          '2',
          'The Details We Give',
          '',
          [
            'Detect positive, negative, or neutral sentiment.',
            'Understand the mood of a community or audience.',
            'Real-time or near-instant results.',
            'Support for hashtags, mentions, and emojis.'
          ],
          Icons.chat_bubble_outline,
          const Offset(-50, 0),
        ),
        const SizedBox(height: 20),
        _buildFeatureCard(
          '3',
          'URL-Based Input',
          'Just paste a link to a post - we fetch the content for you!',
          [
            'We Analyze The Text + image of the post',
            'Show a quick preview of the fetched post to Helps users confirm they submitted the right link.',
            'Show the Analysis with emojies and Scores'
          ],
          Icons.language,
          const Offset(-50, 0),
        ),
        const SizedBox(height: 20),
        _buildFeatureCard(
          '4',
          'Fast And Lightweight',
          '',
          [
            'Optimized for speed - analysis in seconds.',
            'Mobile-friendly interface.',
            'Real-time or near-instant results.',
            'Clean, easy-to-use UI'
          ],
          Icons.timer,
          const Offset(-50, 0),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String number, String title, String description, List<String> platforms, IconData icon, Offset offset) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
          if (platforms.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...platforms.map((platform) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xFF6C63FF),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      platform,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailedFeatures() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why Choose Our Platform?',
            style: TextStyle(
              color: Color(0xFF6C63FF),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
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
        ],
      ),
    );
  }

  Widget _buildDetailedFeatureItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6C63FF),
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
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}