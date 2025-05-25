import 'package:firebase_database/firebase_database.dart';
import 'package:bus_booking/screens/bus_trip.dart';

class AdminTripService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  DatabaseReference _companyBusesRef(String company) =>
      _db.child('busCompanies').child(company).child('buses');

  Future<List<BusTrip>> fetchAll(String company) async {
    final snap = await _companyBusesRef(company).get();
    if (!snap.exists) return [];
    return (snap.value as Map)
        .entries
        .map((e) => BusTrip.fromMap(e.value as Map, e.key, company)) // ✅ Fixed here
        .toList();
  }

  Future<void> add(String company, BusTrip trip) async {
    final newRef = _companyBusesRef(company).push();
    await newRef.set(trip.toMap());
  }

  Future<void> update(String company, BusTrip trip) async {
    await _companyBusesRef(company).child(trip.id!).update(trip.toMap());
  }

  Future<void> delete(String company, String tripId) async {
    await _companyBusesRef(company).child(tripId).remove();
  }
}
