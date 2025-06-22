import 'package:flutter/material.dart';
import 'package:bus_booking/services/bluebus_service.dart';
import 'package:bus_booking/booking/ticket_summary_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

class SeatSelectionScreen extends StatefulWidget {
  final String busNumber;
  final String from;
  final String to;
  final String date;
  final String departureTime;
  final double price;
  final String company;
  final String? locationId;
  final String? toLocationId;
  final String? tripId;
  final String? tripRouteLineId;
  final int? totalSeats;

  const SeatSelectionScreen({
    Key? key,
    required this.busNumber,
    required this.from,
    required this.to,
    required this.date,
    required this.departureTime,
    required this.price,
    required this.company,
    this.locationId,
    this.toLocationId,
    this.tripId,
    this.tripRouteLineId,
    this.totalSeats,
  }) : super(key: key);

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final Set<int> _selectedSeatNumbers = {};
  int _totalSeats = 28;
  bool _loadingSeats = false;
  Set<int> _bookedSeats = {};
  Set<int> _blueBusAvailable = {}; // for reference

  @override
  void initState() {
    super.initState();
    _totalSeats = widget.totalSeats ?? _totalSeats;
    _fetchBookedSeatsAndCount();
  }

  Future<void> _fetchBookedSeatsAndCount() async {
    setState(() => _loadingSeats = true);

    try {
      // 🔒 Load booked seat numbers from Firebase
      final bookedSnapshot = await FirebaseDatabase.instance
          .ref('bookedSeats/${widget.busNumber}_${widget.date}')
          .get();

      final firebaseBooked = <int>{};
      if (bookedSnapshot.exists) {
        final raw = bookedSnapshot.value;
        if (raw is Map) {
          raw.forEach((key, value) {
            final seat = int.tryParse(key.toString());
            if (seat != null) firebaseBooked.add(seat);
          });
        } else if (raw is List) {
          for (int i = 0; i < raw.length; i++) {
            if (raw[i] == true) firebaseBooked.add(i);
          }
        }
      }

      // 🎫 Get detailed seat availability from BlueBus
      Map<String, dynamic> availabilityJson = {};
      if (widget.company == 'BlueBus') {
        try {
          availabilityJson = await BlueBusService.fetchAvailabilityJson(
            tripUuid: widget.busNumber,
            fromLocationId: widget.locationId ?? '',
            toLocationId: widget.toLocationId ?? '',
          );
        } catch (e) {
          print('⚠️ Failed to fetch BlueBus availability JSON: $e');
        }
      }

      Set<int> finalBooked = firebaseBooked;
      int maxSeatNumber = _totalSeats;

      if (widget.company == 'BlueBus' && availabilityJson.isNotEmpty) {
        final blueBusAvailable = <int>{};
        if (availabilityJson['unReservedSeat'] is List) {
          for (final block in (availabilityJson['unReservedSeat'] as List)) {
            if (block is Map && block['seats_numbers'] is List) {
              for (final sn in block['seats_numbers'] as List) {
                final seat = int.tryParse(sn.toString());
                if (seat != null) blueBusAvailable.add(seat);
              }
            }
          }
        }

        // determine total seats
        if (blueBusAvailable.isNotEmpty) {
          maxSeatNumber = blueBusAvailable.reduce(max);
        }

        final computedBooked = <int>{};
        for (int i = 1; i <= maxSeatNumber; i++) {
          if (!blueBusAvailable.contains(i)) computedBooked.add(i);
        }
        finalBooked = {...firebaseBooked, ...computedBooked};

        setState(() {
          _blueBusAvailable = blueBusAvailable;
        });
      }

      setState(() {
        _bookedSeats = finalBooked;
        _totalSeats = max(_totalSeats, maxSeatNumber);
      });
    } catch (e) {
      print('❌ Error loading seats: $e');
    } finally {
      setState(() => _loadingSeats = false);
    }
  }

  void _onSeatSelected(int seatNumber) {
    setState(() {
      if (_selectedSeatNumbers.contains(seatNumber)) {
        _selectedSeatNumbers.remove(seatNumber);
      } else {
        _selectedSeatNumbers.add(seatNumber);
      }
    });
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
          'Select Seat',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF101418),
          ),
        ),
      ),
      body: _loadingSeats
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildLegend(),
                  const SizedBox(height: 16),
                  _buildSeatLayout(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    Widget legendItem(Color color, String label) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _legendBox(color),
          const SizedBox(width: 6),
          Text(label),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        legendItem(const Color(0xFF101418), 'Available'),
        legendItem(const Color(0xFF2E8B57), 'Selected'),
        legendItem(const Color(0xFFD1D5DB), 'Booked'),
      ],
    );
  }

  Widget _legendBox(Color borderColor) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: borderColor == const Color(0xFFD1D5DB)
            ? Colors.grey.shade200
            : Colors.white,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _buildSeatLayout() {
    List<Widget> rows = [];
    final seats = List<int>.generate(_totalSeats, (i) => i + 1);
    const seatSize = 45.0;
    const aisleWidth = 32.0;

    rows.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        SizedBox(width: 40),
        Icon(Icons.directions_bus, color: Colors.grey, size: 40),
        Spacer(),
        Icon(Icons.directions_bus, color: Colors.grey, size: 40),
        SizedBox(width: 40),
      ],
    ));
    rows.add(const SizedBox(height: 12));

    for (int i = 0; i < seats.length; i += 4) {
      final leftSeats = seats.sublist(i, min(i + 2, seats.length));
      final rightSeats = (i + 2 < seats.length)
          ? seats.sublist(i + 2, min(i + 4, seats.length))
          : [];

      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...leftSeats.map((sn) => _seatWidget(sn, seatSize)).toList(),
          const SizedBox(width: aisleWidth),
          ...rightSeats.map((sn) => _seatWidget(sn, seatSize)).toList(),
        ],
      ));

      rows.add(const SizedBox(height: 22));
    }

    return Column(children: rows);
  }

  Widget _seatWidget(int seatNumber, double size) {
    final isSelected = _selectedSeatNumbers.contains(seatNumber);
    final isBooked = _bookedSeats.contains(seatNumber);

    Color borderColor = isSelected
        ? const Color(0xFF2E8B57)
        : const Color(0xFF101418);
    Color fillColor;
    if (isBooked) {
      fillColor = Colors.grey.shade200;
      borderColor = const Color(0xFFD1D5DB);
    } else if (isSelected) {
      fillColor = const Color(0xFF2E8B57);
    } else {
      fillColor = Colors.white;
    }

    return GestureDetector(
      onTap: isBooked ? null : () => _onSeatSelected(seatNumber),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: fillColor,
                border: Border.all(color: borderColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: isBooked
                  ? const Icon(Icons.event_seat, color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(height: 4),
            Text(seatNumber.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final seatText = _selectedSeatNumbers.isEmpty
        ? '-'
        : _selectedSeatNumbers.join(', ');
    final total =
    (_selectedSeatNumbers.length * widget.price).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Selected Seat: $seatText'),
              Text('Total: EGP $total'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedSeatNumbers.isEmpty
                  ? null
                  : () {
                final totalPrice =
                    _selectedSeatNumbers.length * widget.price;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketSummaryScreen(
                      busNumber: widget.busNumber,
                      from: widget.from,
                      to: widget.to,
                      date: widget.date,
                      departureTime: widget.departureTime,
                      price: totalPrice,
                      selectedSeats: _selectedSeatNumbers.toList(),
                      company: widget.company,
                      locationId: widget.locationId,
                      toLocationId: widget.toLocationId,
                      tripId: widget.tripId,
                      tripRouteLineId: widget.tripRouteLineId,
                    ),
                  ),
                );
              },
              child: const Text('Book Now'),
            ),
          ),
        ],
      ),
    );
  }
}
