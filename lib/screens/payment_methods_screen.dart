import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  final String busNumber;
  final String from;
  final String to;
  final String date;
  final String departureTime;
  final double totalAmount;
  final List<int> selectedSeats;

  const PaymentMethodsScreen({
    super.key,
    required this.busNumber,
    required this.from,
    required this.to,
    required this.date,
    required this.departureTime,
    required this.totalAmount,
    required this.selectedSeats,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF101418)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Methods',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF101418),
          ),
        ),
      ),
      body: Column(
        children: [
          // Trip Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      'EGP ${totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF101418),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.directions_bus, color: Color(0xFF2E8B57), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      busNumber,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Payment Methods List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildPaymentMethod(
                  context,
                  'Vodafone Cash',
                  'Pay using your Vodafone Cash wallet',
                  Icons.phone_android,
                      () => _processPayment(context, 'Vodafone Cash'),
                ),
                _buildPaymentMethod(
                  context,
                  'Credit/Debit Card',
                  'Pay using Visa, Mastercard, or other cards',
                  Icons.credit_card,
                      () => _processPayment(context, 'Credit/Debit Card'),
                ),
                _buildPaymentMethod(
                  context,
                  'Fawry',
                  'Pay at any Fawry outlet',
                  Icons.store,
                      () => _processPayment(context, 'Fawry'),
                ),
                _buildPaymentMethod(
                  context,
                  'Aman',
                  'Pay using Aman wallet',
                  Icons.account_balance_wallet,
                      () => _processPayment(context, 'Aman'),
                ),
                _buildPaymentMethod(
                  context,
                  'On Board',
                  'Pay when you board the bus',
                  Icons.directions_bus,
                      () => _processPayment(context, 'On Board'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      VoidCallback onTap,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E8B57).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF2E8B57),
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
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF101418),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF101418),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _processPayment(BuildContext context, String method) {
    // TODO: Implement actual payment processing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processing payment via $method...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
} 