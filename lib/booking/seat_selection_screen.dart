import 'package:bus_booking/booking/ticket_summary_screen.dart';
import 'package:flutter/material.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String busNumber;
  final String from;
  final String to;
  final String date;
  final String departureTime;
  final double price;
  final String company;

  const SeatSelectionScreen({
    super.key,
    required this.busNumber,
    required this.from,
    required this.to,
    required this.date,
    required this.departureTime,
    required this.price,
    required this.company,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final List<int> _bookedSeats = [];
  final int _rows = 11;
  final int _cols = 4;
  final Set<int> _selectedSeats = {};

  String getRowLabel(int row) => String.fromCharCode('A'.codeUnitAt(0) + row);
  String getSeatLabel(int index) {
    int row = index ~/ _cols;
    int col = index % _cols;
    return '${String.fromCharCode(65 + col)}${row + 1}';
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = _selectedSeats.length * widget.price;

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
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.directions_bus,
                      color: Colors.grey, size: 28),
                ),
                const SizedBox(width: 100),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.directions_bus,
                      color: Colors.grey, size: 28),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: List.generate(_rows, (row) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(2, (col) {
                              int index = row * _cols + col;
                              bool isSelected =
                              _selectedSeats.contains(index + 1);
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _buildSeat(index, isSelected),
                              );
                            }),
                          ),
                          Row(
                            children: List.generate(2, (col) {
                              int index = row * _cols + col + 2;
                              bool isSelected =
                              _selectedSeats.contains(index + 1);
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _buildSeat(index, isSelected),
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendBox(const Color(0xFF101418)),
                const SizedBox(width: 4),
                const Text('Available', style: TextStyle(fontSize: 13, color: Color(0xFF101418))),
                const SizedBox(width: 16),
                _buildLegendBox(const Color(0xFF2E8B57)),
                const SizedBox(width: 4),
                const Text('Selected', style: TextStyle(fontSize: 13, color: Color(0xFF101418))),
                const SizedBox(width: 16),
                _buildLegendBox(const Color(0xFFD1D5DB)),
                const SizedBox(width: 4),
                const Text('Booked', style: TextStyle(fontSize: 13, color: Color(0xFF101418))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedSeats.isEmpty
                        ? 'Selected Seat: -'
                        : 'Selected Seat: ${_selectedSeats.map((s) => getSeatLabel(s - 1)).join(",")}',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xFF101418),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Total: EGP ${totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF101418),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _selectedSeats.isEmpty
                    ? null
                    : () {
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
                        selectedSeats: _selectedSeats.toList(),
                        company: widget.company,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E8B57),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                child: const Text('Book Now', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeat(int index, bool isSelected) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedSeats.remove(index + 1);
              } else {
                _selectedSeats.add(index + 1);
              }
            });
          },
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2E8B57) : Colors.white,
              border: Border.all(
                color: isSelected ? const Color(0xFF2E8B57) : const Color(0xFF101418),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${index + 1}',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            color: Color(0xFF101418),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color == const Color(0xFFD1D5DB) ? Colors.grey.shade200 : Colors.white,
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
