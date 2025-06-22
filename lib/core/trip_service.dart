import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:bus_booking/core/bus_trip.dart';
import 'package:bus_booking/services/bluebus_service.dart';
import 'package:bus_booking/helpers/city_mapper.dart';

class TripService {
  static final List<String> companies = ['WeBus', 'FastGo'];

  /// ✅ Stream all Firebase trips (live updates)
  static Stream<List<BusTrip>> streamAllTrips() {
    final db = FirebaseDatabase.instance.ref().child('busCompanies');
    final controller = StreamController<List<BusTrip>>.broadcast();

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

  /// ✅ Fetch all Firebase trips once
  static Future<List<BusTrip>> fetchAllTrips() async {
    List<BusTrip> allTrips = [];

    for (String company in companies) {
      final ref = FirebaseDatabase.instance.ref('busCompanies/$company/buses');
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          if (value is Map) {
            final trip = BusTrip.fromMap(value, key, company);
            allTrips.add(trip);
          }
        });
      }
    }

    return allTrips;
  }

  /// 🔍 Search both Firebase & Blue Bus trips by city and date
  static Future<List<BusTrip>> searchTrips({
    required String from,
    required String to,
    required String date,
  }) async {
    final fromCityId = mapCityToBlueBusId(from);
    final toCityId = mapCityToBlueBusId(to);

    // 🟡 Filter Firebase trips
    final firebaseTrips = await fetchAllTrips();
    final firebaseResults = firebaseTrips.where((trip) =>
        trip.fromCityId == fromCityId &&
        trip.toCityId == toCityId &&
        trip.dateOnly == date
    ).toList();

    // 🔵 Fetch BlueBus trips
    List<BusTrip> blueBusMappedTrips = [];
    try {
      final blueBusTrips = await BlueBusService.searchTripsByCity(
        fromCityId: fromCityId.toString(),
        toCityId: toCityId.toString(),
        travelDate: date,
      );

      for (final trip in blueBusTrips) {
        int availableSeats = 40;
        try {
          availableSeats = await BlueBusService.fetchAvailableSeats(
            tripUuid: trip.tripId,
            fromLocationId: trip.fromLocationId,
            toLocationId: trip.toLocationId,
          );
        } catch (e) {
          print('⚠️ Failed to fetch seats for ${trip.tripId}: $e');
        }

        blueBusMappedTrips.add(BusTrip.fromBlueBusModel(trip).copyWith(
          seatsAvailable: availableSeats,
        ));
      }
    } catch (e) {
      print("🔴 Error loading Blue Bus trips: $e");
    }

    // ✅ Remove duplicates (same trip id)
    final blueIds = blueBusMappedTrips.map((t) => t.id).toSet();
    final uniqueFirebaseTrips = firebaseResults.where((t) => !blueIds.contains(t.id)).toList();

    return [...uniqueFirebaseTrips, ...blueBusMappedTrips]
      ..sort((a, b) => a.departureTime.compareTo(b.departureTime));
  }

  /// 📌 Get all trips going to a specific city
  static Future<List<BusTrip>> tripsTo(String destination) async {
    final trips = await fetchAllTrips();
    return trips.where((trip) => trip.to == destination).toList();
  }

  /// 🔎 Find a trip by from, to, and time
  static Future<BusTrip?> findTrip(String from, String to, String departureTime) async {
    final trips = await fetchAllTrips();
    try {
      return trips.firstWhere((trip) =>
      trip.from == from &&
          trip.to == to &&
          trip.departureTime == departureTime,
      );
    } catch (_) {
      return null;
    }
  }
}
