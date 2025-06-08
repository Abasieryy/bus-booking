import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bus_booking/screens/seat_selection_screen.dart';
import 'package:bus_booking/screens/bus_trip.dart';
import 'package:bus_booking/screens/trip_service.dart';

class SearchResultsScreen extends StatefulWidget {
  final String from;
  final String to;
  final String date;

  const SearchResultsScreen({
    required this.from,
    required this.to,
    required this.date,
    Key? key,
  }) : super(key: key);

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late StreamSubscription<List<BusTrip>> _tripSubscription;
  List<BusTrip> _trips = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    final formattedDate = _formatDate(widget.date); // convert widget.date

    _tripSubscription = TripService.streamAllTrips().listen((allTrips) {
      final results = allTrips
          .where((trip) =>
      trip.from == widget.from &&
          trip.to == widget.to &&
          trip.dateOnly == formattedDate) // now both dates match
          .toList();

      setState(() {
        _trips = results;
        _loading = false;
      });
      _trips.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    });
  }

  @override
  void dispose() {
    _tripSubscription.cancel();
    super.dispose();
  }

  // ✅ Helper function to format widget.date → yyyy-MM-dd
  String _formatDate(String inputDate) {
    List<String> parts = inputDate.split(', ');
    String monthDay = parts[0]; // "Jul 03"
    String year = parts[1]; // "2025"

    List<String> monthDayParts = monthDay.split(' ');
    String monthName = monthDayParts[0]; // "Jul"
    String day = monthDayParts[1]; // "03"

    Map<String, String> monthMap = {
      'Jan': '01',
      'Feb': '02',
      'Mar': '03',
      'Apr': '04',
      'May': '05',
      'Jun': '06',
      'Jul': '07',
      'Aug': '08',
      'Sep': '09',
      'Oct': '10',
      'Nov': '11',
      'Dec': '12',
    };

    String month = monthMap[monthName] ?? '01';

    return '$year-$month-$day'; // "YYYY-MM-DD"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF101418), Color(0xFF14532D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.directions_bus,
                      color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  const Text(
                    'Available Trips',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _trips.isEmpty
          ? const Center(child: Text('No trips found.'))
          : Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 16, color: Color(0xFF1E3A8A)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.from,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF101418),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Color(0xFF1E3A8A)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.to,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF101418),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.date,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF101418),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _trips.length,
              itemBuilder: (context, index) {
                final trip = _trips[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text('${trip.from} → ${trip.to}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${trip.departureTime} · EGP ${trip.price}'),
                        Text('Company: ${trip.company}',
                            style: TextStyle(
                                color: Colors.grey[600])),
                      ],
                    ),
                    trailing: Text('Seats: ${trip.seatsAvailable}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeatSelectionScreen(
                            busNumber: trip.id ?? 'Bus',
                            from: trip.from,
                            to: trip.to,
                            date: widget.date,
                            departureTime: trip.departureTime,
                            price: trip.price.toDouble(),
                            company: trip.company,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
