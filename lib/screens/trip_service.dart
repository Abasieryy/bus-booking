import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:bus_booking/screens/bus_trip.dart';

class TripService {
  static final List<String> companies = ['WeBus', 'FastGo'];

  /// Stream real-time updates for all trips
  static Stream<List<BusTrip>> streamAllTrips() {
    final db = FirebaseDatabase.instance.ref().child('busCompanies');
    final controller = StreamController<List<BusTrip>>();

    db.onValue.listen((event) {
      final data = event.snapshot.value;
      List<BusTrip> allTrips = [];

      if (data is Map) {
        data.forEach((companyName, companyData) {
          if (companyData is Map && companyData['buses'] is Map) {
            final buses = companyData['buses'] as Map;
            buses.forEach((tripId, tripData) {
              if (tripData is Map) {
                allTrips.add(BusTrip.fromMap(tripData, tripId, companyName));
              }
            });
          }
        });
      }

      controller.add(allTrips);
    });

    return controller.stream;
  }


  /// Fetch all trips once
  static Future<List<BusTrip>> fetchAllTrips() async {
    List<BusTrip> allTrips = [];

    for (String company in companies) {
      final ref = FirebaseDatabase.instance.ref('busCompanies/$company/buses');
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          final trip = BusTrip.fromMap(value, key, company);
          allTrips.add(trip);
        });
      }
    }

    return allTrips;
  }

  /// Search for trips by from/to
  static Future<List<BusTrip>> searchTrips(String from, String to) async {
    final trips = await fetchAllTrips();
    return trips.where((trip) => trip.from == from && trip.to == to).toList();
  }

  /// Get all trips to a specific destination
  static Future<List<BusTrip>> tripsTo(String destination) async {
    final trips = await fetchAllTrips();
    return trips.where((trip) => trip.to == destination).toList();
  }

  /// Find a trip by exact info
  static Future<BusTrip?> findTrip(String from, String to, String departureTime) async {
    final trips = await fetchAllTrips();
    try {
      return trips.firstWhere(
            (trip) =>
        trip.from == from &&
            trip.to == to &&
            trip.departureTime == departureTime,
      );
    } catch (e) {
      return null;
    }
  }
}
