import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF101418),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // Example number of notifications
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getNotificationColor(index).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(index),
                  color: _getNotificationColor(index),
                ),
              ),
              title: Text(
                _getNotificationTitle(index),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    _getNotificationMessage(index),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${index + 1} hour${index == 0 ? '' : 's'} ago',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getNotificationIcon(int index) {
    switch (index % 4) {
      case 0:
        return Icons.confirmation_number;
      case 1:
        return Icons.local_offer;
      case 2:
        return Icons.notifications_active;
      default:
        return Icons.info;
    }
  }

  Color _getNotificationColor(int index) {
    switch (index % 4) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      default:
        return Colors.purple;
    }
  }

  String _getNotificationTitle(int index) {
    switch (index % 4) {
      case 0:
        return 'Booking Confirmed';
      case 1:
        return 'Special Offer';
      case 2:
        return 'Trip Reminder';
      default:
        return 'System Update';
    }
  }

  String _getNotificationMessage(int index) {
    switch (index % 4) {
      case 0:
        return 'Your booking for Cairo to Alexandria has been confirmed.';
      case 1:
        return 'Get 20% off on your next booking! Use code: SPECIAL20';
      case 2:
        return 'Your trip to Alexandria is scheduled for tomorrow at 8:00 AM.';
      default:
        return 'We have updated our app with new features. Check them out!';
    }
  }
} 