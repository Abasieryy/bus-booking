import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF101418),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // App Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF14532D).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_bus,
                size: 50,
                color: Color(0xFF14532D),
              ),
            ),
            const SizedBox(height: 20),
            // App Name
            const Text(
              'Bus Booking',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Version
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),
            // About Section
            _buildSection(
              title: 'About Us',
              content:
                  'Bus Booking is your trusted partner for convenient and comfortable bus travel across Egypt. We connect major cities and tourist destinations with reliable bus services, ensuring a smooth journey for all our passengers.',
            ),
            const SizedBox(height: 20),
            // Mission Section
            _buildSection(
              title: 'Our Mission',
              content:
                  'To provide safe, comfortable, and affordable bus transportation services while ensuring the highest standards of customer satisfaction and environmental responsibility.',
            ),
            const SizedBox(height: 20),
            // Features Section
            _buildSection(
              title: 'Key Features',
              content: '',
              isFeatures: true,
            ),
            const SizedBox(height: 20),
            // Contact Section
            _buildSection(
              title: 'Contact Information',
              content: '',
              isContact: true,
            ),
            const SizedBox(height: 20),
            // Social Media Section
            _buildSection(
              title: 'Follow Us',
              content: '',
              isSocial: true,
            ),
            const SizedBox(height: 40),
            // Copyright
            Text(
              '© 2024 Bus Booking. All rights reserved.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    bool isFeatures = false,
    bool isContact = false,
    bool isSocial = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (isFeatures)
          Column(
            children: [
              _buildFeatureItem(Icons.check_circle, 'Easy Booking Process'),
              _buildFeatureItem(Icons.security, 'Secure Payments'),
              _buildFeatureItem(Icons.notifications, 'Real-time Updates'),
              _buildFeatureItem(Icons.support_agent, '24/7 Customer Support'),
              _buildFeatureItem(Icons.location_on, 'Multiple Routes'),
            ],
          )
        else if (isContact)
          Column(
            children: [
              _buildContactItem(Icons.phone, '+20 123 456 7890'),
              _buildContactItem(Icons.email, 'info@busbooking.com'),
              _buildContactItem(Icons.location_on, '123 Main St, Cairo, Egypt'),
            ],
          )
        else if (isSocial)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(Icons.facebook, Colors.blue),
              const SizedBox(width: 16),
              _buildSocialButton(Icons.camera_alt, Colors.pink),
              const SizedBox(width: 16),
              _buildSocialButton(Icons.language, Colors.blue),
            ],
          )
        else
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF14532D), size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF14532D), size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color),
    );
  }
} 