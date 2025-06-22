import 'package:flutter/material.dart';
import 'package:bus_booking/booking/payment_methods_screen.dart';

class TicketSummaryScreen extends StatefulWidget {
  final String busNumber;
  final String from;
  final String to;
  final String date;
  final String departureTime;
  final double price;
  final List<int> selectedSeats;
  final String company;
  final String? locationId;
  final String? toLocationId;
  final String? tripId;
  final String? tripRouteLineId;

  const TicketSummaryScreen({
    super.key,
    required this.busNumber,
    required this.from,
    required this.to,
    required this.date,
    required this.departureTime,
    required this.price,
    required this.selectedSeats,
    required this.company,
    this.locationId,
    this.toLocationId,
    this.tripId,              // ✅ Add this
    this.tripRouteLineId,
  });

  @override
  State<TicketSummaryScreen> createState() => _TicketSummaryScreenState();
}

class _TicketSummaryScreenState extends State<TicketSummaryScreen> {
  final TextEditingController _promoCodeController = TextEditingController();
  bool _isPromoApplied = false;
  double _discount = 0.0;

  String getSeatLabel(int index) {
    int row = index ~/ 4;
    int col = index % 4;
    return '${String.fromCharCode(65 + col)}${row + 1}';
  }

  void _applyPromoCode() {
    if (_promoCodeController.text.toUpperCase() == 'WELCOME10') {
      setState(() {
        _isPromoApplied = true;
        _discount = 0.10;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Promo code applied successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid promo code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double basePrice = widget.price;
    final double discountAmount = basePrice * _discount;
    final double finalPrice = basePrice - discountAmount;

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
          'Ticket Summary',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF101418),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.busNumber,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF101418))),
                          const SizedBox(height: 4),
                          Text('Company: ${widget.company}',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600)),
                          const SizedBox(height: 4),
                          Text('${widget.selectedSeats.length} Seats Selected',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E8B57).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Confirmed',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF2E8B57),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.event_seat, color: Color(0xFF2E8B57), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Seats: ${widget.selectedSeats.map((s) => getSeatLabel(s - 1)).join(", ")}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Price summary
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Base Price', style: TextStyle(fontSize: 14)),
                      Text('EGP ${basePrice.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  if (_isPromoApplied) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Discount',
                            style: TextStyle(fontSize: 14, color: Color(0xFF2E8B57))),
                        Text('-EGP ${discountAmount.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 14, color: Color(0xFF2E8B57))),
                      ],
                    ),
                  ],
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('EGP ${finalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),

            // Pay now
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentMethodsScreen(
                          busNumber: widget.busNumber,
                          from: widget.from,
                          to: widget.to,
                          date: widget.date,
                          departureTime: widget.departureTime,
                          totalAmount: finalPrice,
                          selectedSeats: widget.selectedSeats,
                          company: widget.company,
                          locationId: widget.locationId,
                          toLocationId: widget.toLocationId,
                          tripId: widget.tripId,
                          tripRouteLineId: widget.tripRouteLineId,
                        ),
                      ),
                    );
                  },
                  child: const Text("Pay Now"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateArrivalTime(String departureTime) {
    try {
      final parts = departureTime.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final departure = DateTime(0, 1, 1, hour, minute);
      final arrival = departure.add(const Duration(hours: 2));
      return '${arrival.hour.toString().padLeft(2, '0')}:${arrival.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '--:--';
    }
  }
}
