import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF101418),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Support Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact Support',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildContactOption(
                      icon: Icons.phone,
                      title: 'Call Us',
                      subtitle: '+20 123 456 7890',
                      onTap: () {
                        // TODO: Implement call functionality
                      },
                    ),
                    const Divider(),
                    _buildContactOption(
                      icon: Icons.email,
                      title: 'Email Us',
                      subtitle: 'support@busbooking.com',
                      onTap: () {
                        // TODO: Implement email functionality
                      },
                    ),
                    const Divider(),
                    _buildContactOption(
                      icon: Icons.chat,
                      title: 'Live Chat',
                      subtitle: 'Available 24/7',
                      onTap: () {
                        // TODO: Implement chat functionality
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // FAQ Section
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFAQItem(
              question: 'How do I book a bus ticket?',
              answer:
                  'To book a bus ticket, simply select your departure and destination cities, choose your preferred date and time, and follow the booking process. You can pay using various payment methods including credit cards and mobile wallets.',
            ),
            _buildFAQItem(
              question: 'Can I cancel my booking?',
              answer:
                  'Yes, you can cancel your booking up to 24 hours before the scheduled departure time. Cancellations made within 24 hours may be subject to a cancellation fee.',
            ),
            _buildFAQItem(
              question: 'How do I get my ticket?',
              answer:
                  'After successful booking, you will receive an e-ticket via email and SMS. You can also view your ticket in the app under the "Booking History" section.',
            ),
            _buildFAQItem(
              question: 'What payment methods are accepted?',
              answer:
                  'We accept various payment methods including credit/debit cards, mobile wallets, and cash payments at our authorized agents.',
            ),
            _buildFAQItem(
              question: 'Is there a mobile app available?',
              answer:
                  'Yes, you can download our mobile app from the App Store (iOS) or Google Play Store (Android) for a better booking experience.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF14532D).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF14532D),
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
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 