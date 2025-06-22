// lib/booking/search_results_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bus_booking/booking/seat_selection_screen.dart';
import 'package:bus_booking/core/bus_trip.dart';
import 'package:bus_booking/core/trip_service.dart';
import 'package:bus_booking/services/bluebus_service.dart';
import 'package:bus_booking/helpers/city_mapper.dart';
import 'package:bus_booking/widgets/station_picker_sheet.dart';
import 'package:bus_booking/widgets/rounded_input_field.dart';

class SearchResultsScreen extends StatefulWidget {
  final String from;
  final String to;
  final String date;
  final String fromLocationId;
  final String toLocationId;

  const SearchResultsScreen({
    required this.from,
    required this.to,
    required this.date,
    required this.fromLocationId,
    required this.toLocationId,
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
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    final formattedDate = _formatDate(widget.date);

    _tripSubscription = TripService.streamAllTrips().listen((firebaseTrips) async {
      final fromCityId = mapCityToBlueBusId(widget.from);
      final toCityId   = mapCityToBlueBusId(widget.to);

      final filteredFirebaseTrips = firebaseTrips.where((trip) =>
          trip.fromCityId == fromCityId &&
          trip.toCityId   == toCityId   &&
          trip.dateOnly   == formattedDate
      ).toList();

      List<BusTrip> blueBusMappedTrips = [];

      try {
        await BlueBusService.loginAndStoreToken();

        final blueBusTrips = await BlueBusService.searchTripsByCity(
          fromCityId: fromCityId.toString(),
          toCityId: toCityId.toString(),
          travelDate: formattedDate,
        );

        for (var trip in blueBusTrips) {
          int availableSeats = 40;
          try {
            availableSeats = await BlueBusService.fetchAvailableSeats(
              tripUuid: trip.tripId,
              fromLocationId: trip.fromLocationId.isNotEmpty
                  ? trip.fromLocationId
                  : widget.fromLocationId,
              toLocationId: trip.toLocationId.isNotEmpty
                  ? trip.toLocationId
                  : widget.toLocationId,
            );
          } catch (e) {
            print('⚠️ Failed to fetch seats for ${trip.tripId}: $e');
          }

          final tripModel = BusTrip.fromBlueBusModel(trip).copyWith(
            from: trip.fromCity.isNotEmpty ? trip.fromCity : widget.from,
            to: trip.toCity.isNotEmpty ? trip.toCity : widget.to,
            departureTime: trip.departureTime.isNotEmpty ? trip.departureTime : formattedDate,
            price: int.tryParse(trip.price) ?? double.tryParse(trip.price)?.round() ?? 0,
            seatsAvailable: availableSeats,
          );

          if (availableSeats > 0) {
            blueBusMappedTrips.add(tripModel);
          }
        }
      } catch (e) {
        print("🔴 Blue Bus Error: $e");
      }

      if (!mounted) return;

      final blueIds = blueBusMappedTrips.map((t) => t.id).toSet();
      final uniqueFirebaseTrips = filteredFirebaseTrips.where((t) => !blueIds.contains(t.id)).toList();

      setState(() {
        _trips = [...uniqueFirebaseTrips, ...blueBusMappedTrips]
          ..sort((a, b) => a.departureTime.compareTo(b.departureTime));
        _loading = false;
      });
    });
  }

  String _formatDate(String inputDate) {
    List<String> parts = inputDate.split(', ');
    String monthDay = parts[0];
    String year = parts[1];
    List<String> monthDayParts = monthDay.split(' ');
    String monthName = monthDayParts[0];
    String day = monthDayParts[1];

    Map<String, String> monthMap = {
      'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04', 'May': '05', 'Jun': '06',
      'Jul': '07', 'Aug': '08', 'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12',
    };
    String month = monthMap[monthName] ?? '01';
    return '$year-$month-$day';
  }

  @override
  void dispose() {
    _tripSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: _buildAppBar(),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _trips.isEmpty
          ? const Center(child: Text('No trips found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _trips.length,
        itemBuilder: (context, index) {
          final trip = _trips[index];
          return _buildTripCard(trip);
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
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
          BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.directions_bus, color: Colors.white, size: 32),
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
    );
  }

  Widget _buildTripCard(BusTrip trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        title: Text('${trip.from} → ${trip.to}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${trip.timeOnly} · EGP ${trip.price}'),
            Text('Company: ${trip.company}', style: TextStyle(color: Colors.grey[600])),
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
                locationId: (trip.locationId ?? widget.fromLocationId),
                toLocationId: (trip.toLocationId?.toString() ?? widget.toLocationId),
                tripId: trip.id,
                tripRouteLineId: trip.tripRouteLineId,
                totalSeats: trip.seatsAvailable,
              ),
            ),
          );
        },
      ),
    );
  }
}
