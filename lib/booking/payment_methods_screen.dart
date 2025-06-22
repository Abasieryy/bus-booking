import 'package:flutter/material.dart';
import 'package:flutter_paymob/flutter_paymob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bus_booking/services/bluebus_service.dart';

class PaymentMethodsScreen extends StatelessWidget {
  final String busNumber;
  final String from;
  final String to;
  final String date;
  final String departureTime;
  final double totalAmount;
  final List<int> selectedSeats;
  final String company;
  final String? locationId;
  final String? toLocationId;
  final String? tripId;
  final String? tripRouteLineId;

  const PaymentMethodsScreen({
    super.key,
    required this.busNumber,
    required this.from,
    required this.to,
    required this.date,
    required this.departureTime,
    required this.totalAmount,
    required this.selectedSeats,
    required this.company,
    this.locationId,
    this.toLocationId,
    this.tripId,
    this.tripRouteLineId,
  });

  Future<void> _bookAndStore(BuildContext context, {bool payLater = false}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be logged in')),
      );
      return;
    }

    try {
      if (company == 'BlueBus') {
        await BlueBusService.bookTrip(
          busNumber: busNumber,
          from: from,
          to: to,
          date: date,
          departureTime: departureTime,
          company: company,
          selectedSeats: selectedSeats,
          totalAmount: totalAmount,
          context: context,
          locationId: locationId,
          toLocationId: toLocationId,
          tripId: tripId,
          tripRouteLineId: tripRouteLineId,
          payLater: payLater,
        );
      } else {
        final userRef = FirebaseDatabase.instance
            .ref('users/$uid/upcomingTrips')
            .push();

        await userRef.set({
          'busNumber': busNumber,
          'from': from,
          'to': to,
          'date': date,
          'departureTime': departureTime,
          'total': totalAmount,
          'seats': selectedSeats,
          'company': company,
          'paid': !payLater,
        });

        final bookedRef = FirebaseDatabase.instance
            .ref('bookedSeats/${busNumber}_$date');

        for (final seat in selectedSeats) {
          await bookedRef.child(seat.toString()).set(true);
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                payLater ? 'Trip booked. Pay on board 🚌' : 'Booking successful 🚌',
              ),
            ),
          );
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
        }
      }
    } catch (e) {
      print('❌ Booking failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking failed. Please try again.')),
      );
    }
  }

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
          _buildSummaryCard(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildPaymentMethod(
                  context,
                  'Credit / Debit Card',
                  'Pay using Visa / MasterCard / Meeza',
                  Icons.credit_card,
                      () {
                    FlutterPaymob.instance.payWithCard(
                      context: context,
                      currency: 'EGP',
                      amount: totalAmount,
                      onPayment: (response) {
                        if (response.success == true) {
                          _bookAndStore(context);
                        }
                      },
                    );
                  },
                ),
                _buildPaymentMethod(
                  context,
                  'Vodafone Cash',
                  'Pay using your Vodafone Cash wallet',
                  Icons.phone_android,
                      () {
                    FlutterPaymob.instance.payWithWallet(
                      context: context,
                      currency: 'EGP',
                      amount: totalAmount,
                      number: '01010101010',
                      onPayment: (response) {
                        if (response.success == true) {
                          _bookAndStore(context);
                        }
                      },
                    );
                  },
                ),
                _buildPaymentMethod(
                  context,
                  'Fawry',
                  'Pay at any Fawry outlet',
                  Icons.store,
                      () => _processPayment(context, 'Fawry (Coming Soon)'),
                ),
                _buildPaymentMethod(
                  context,
                  'Aman',
                  'Pay using Aman wallet',
                  Icons.account_balance_wallet,
                      () {
                    FlutterPaymob.instance.payWithWallet(
                      context: context,
                      currency: 'EGP',
                      amount: totalAmount,
                      number: '01010101010',
                      onPayment: (response) {
                        if (response.success == true) {
                          _bookAndStore(context);
                        }
                      },
                    );
                  },
                ),
                _buildPaymentMethod(
                  context,
                  'On Board',
                  'Pay when you board the bus',
                  Icons.directions_bus,
                      () async => await _bookAndStore(context, payLater: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
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
              Text('Total Amount',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: Colors.grey.shade600)),
              Text('EGP ${totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF101418))),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.directions_bus,
                  color: Color(0xFF2E8B57), size: 20),
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
                  child: Icon(icon, color: const Color(0xFF2E8B57), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF101418))),
                      const SizedBox(height: 4),
                      Text(subtitle,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 13,
                              color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Color(0xFF101418), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _processPayment(BuildContext context, String method) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processing payment via $method...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
