import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserTripService {
  static Stream<List<Map<String, dynamic>>> upcomingTrips() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Stream.empty();
    }
    return FirebaseDatabase.instance
        .ref('users/$uid/upcomingTrips')
        .onValue
        .map((event) {
      if (event.snapshot.value is! Map) return <Map<String, dynamic>>[];
      final data = event.snapshot.value as Map;
      return data.values
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    });
  }
} 