import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bus_booking/models/bluebus_trip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:bus_booking/core/trip_service.dart';
import 'package:bus_booking/core/user_trip_service.dart';

class BlueBusService {
  static const String baseUrl = 'http://10.0.2.2:3000/proxy'; // For emulator

  static Future<void> loginAndStoreToken() async {
    print('✅ Token will be handled by proxy');
  }

  static Future<List<BlueBusTrip>> searchTripsByCity({
    required String fromCityId,
    required String toCityId,
    required String travelDate,
  }) async {
    final uri = Uri.parse('$baseUrl/search-trip-by-city');

    final request = http.MultipartRequest('POST', uri)
      ..fields['from_city_id'] = fromCityId
      ..fields['to_city_id'] = toCityId
      ..fields['travel_date'] = travelDate;

    final streamedRes = await request.send();
    final body = await streamedRes.stream.bytesToString();

    if (streamedRes.statusCode == 200) {
      final json = jsonDecode(body);
      final tripsJson = (json['data'] is List) ? json['data'] : [];
      print('🔵 raw Blue Bus trip json → $tripsJson');
      return List<BlueBusTrip>.from(tripsJson.map((e) => BlueBusTrip.fromJson(e)));
    } else {
      throw Exception('❌ Trip search failed: $body');
    }
  }

  static Future<int> fetchAvailableSeats({
    required String tripUuid,
    required String fromLocationId,
    required String toLocationId,
  }) async {
    final uri = Uri.parse('$baseUrl/trip-available-seats');

    final request = http.MultipartRequest('POST', uri)
      ..fields['trip_id'] = tripUuid
      ..fields['from_location_id'] = fromLocationId
      ..fields['to_location_id'] = toLocationId;

    final streamedRes = await request.send();
    final body = await streamedRes.stream.bytesToString();

    if (streamedRes.statusCode == 200) {
      final json = jsonDecode(body);
      int count = 0;

      if (json['unReservedSeat'] is List) {
        for (final item in (json['unReservedSeat'] as List)) {
          if (item is Map && item['seats_numbers'] is List) {
            count += (item['seats_numbers'] as List).length;
          } else if (item is Map && item['count'] != null) {
            count += int.tryParse(item['count'].toString()) ?? 0;
          }
        }
      } else if (json['data'] is List) {
        count = (json['data'] as List).length;
      } else if (json['data'] is Map) {
        final mapData = json['data'] as Map;
        if (mapData['data'] is Map) {
          final nested = mapData['data'] as Map;
          if (nested['available_seats'] is List) {
            count = (nested['available_seats'] as List).length;
          } else if (nested['free_seats'] != null) {
            count = int.tryParse(nested['free_seats'].toString()) ?? 0;
          }
        } else if (mapData['free_seats'] != null) {
          count = int.tryParse(mapData['free_seats'].toString()) ?? 0;
        }
      }

      return count;
    } else {
      throw Exception('❌ Seat fetch failed: $body');
    }
  }

  /// 👉 Fetch full availability JSON (seat blocks) for later seat-type mapping
  static Future<Map<String, dynamic>> fetchAvailabilityJson({
    required String tripUuid,
    required String fromLocationId,
    required String toLocationId,
  }) async {
    final uri = Uri.parse('$baseUrl/trip-available-seats');

    final request = http.MultipartRequest('POST', uri)
      ..fields['trip_id'] = tripUuid
      ..fields['from_location_id'] = fromLocationId
      ..fields['to_location_id'] = toLocationId;

    final streamedRes = await request.send();
    final body = await streamedRes.stream.bytesToString();

    if (streamedRes.statusCode == 200) {
      return jsonDecode(body) as Map<String, dynamic>;
    }
    throw Exception('Seat availability fetch failed: $body');
  }

  /// 🔎 Try to fetch the trip_route_line_id for a given trip
  static Future<String> fetchRouteLineId({
    required String tripUuid,
    required String fromLocationId,
    required String toLocationId,
  }) async {
    final uri = Uri.parse('$baseUrl/trip-available-seats');

    final request = http.MultipartRequest('POST', uri)
      ..fields['trip_id'] = tripUuid
      ..fields['from_location_id'] = fromLocationId;

    if (toLocationId.isNotEmpty) {
      request.fields['to_location_id'] = toLocationId;
    }

    final streamedRes = await request.send();
    final body = await streamedRes.stream.bytesToString();

    print('📦 fetchRouteLineId response for $tripUuid => $body');

    if (streamedRes.statusCode == 200) {
      final json = jsonDecode(body);

      String tryKeys(Map m, List<String> keys) {
        for (final k in keys) {
          if (m.containsKey(k) && m[k] != null && m[k].toString().isNotEmpty) {
            return m[k].toString();
          }
        }
        return '';
      }

      // Check root level
      final rootCandidate = tryKeys(json, [
        'trip_route_line_id',
        'route_line_id',
        'trip_route_id',
        'trip_route_line_uuid',
        'tripRouteLineId',
        'tripRouteLineID',
        'trip_route_line',
        'uuid'
      ]);
      if (rootCandidate.isNotEmpty) return rootCandidate;

      // Check nested structures
      if (json.values.any((e) => e is Map || e is List)) {
        List<dynamic> stack = [json];
        while (stack.isNotEmpty) {
          final current = stack.removeLast();
          if (current is Map) {
            final found = tryKeys(current, [
              'trip_route_line_id',
              'route_line_id',
              'trip_route_id',
              'trip_route_line_uuid',
              'tripRouteLineId',
              'trip_route_line',
              'uuid'
            ]);
            if (found.isNotEmpty) return found;
            current.values.forEach((v) => stack.add(v));
          } else if (current is List) {
            stack.addAll(current);
          }
        }
      }
    }
    return '';
  }

  static Future<void> bookTrip({
    required String busNumber,
    required String from,
    required String to,
    required String date,
    required String departureTime,
    required String company,
    required List<int> selectedSeats,
    required double totalAmount,
    required BuildContext context,
    String? locationId,
    String? toLocationId,
    String? tripId,
    String? tripRouteLineId,
    bool payLater = false,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Not signed in')));
      return;
    }
    final uid = user.uid;

    try {
      bool bluebusSuccess = false;

      if (company == 'BlueBus' && !payLater) {
        String routeLineIdFinal = tripRouteLineId ?? '';
        if (routeLineIdFinal.isEmpty && tripId != null && tripId.isNotEmpty) {
          try {
            routeLineIdFinal = await fetchRouteLineId(
              tripUuid: tripId!,
              fromLocationId: locationId ?? '',
              toLocationId: toLocationId ?? '',
            );
          } catch (e) {
            print('⚠️ Could not fetch route line id: $e');
          }
        }

        print('🛣️ Using tripRouteLineId: $routeLineIdFinal for trip $tripId');

        Map<String, dynamic> availabilityJson = {};
        Map<String, String> seatMap = {};
        if (tripId != null && tripId.isNotEmpty) {
          try {
            availabilityJson = await fetchAvailabilityJson(
              tripUuid: tripId,
              fromLocationId: locationId ?? '',
              toLocationId: toLocationId ?? '',
            );
            seatMap = _seatToType(availabilityJson);
          } catch (e) {
            print('⚠️ Could not fetch availability JSON: $e');
          }
        }

        final pendingOrderPayload = {
          "customer": {
            "name": user.displayName ?? "guest",
            "email": user.email ?? "test@bluebus.com",
            "phone": user.phoneNumber ?? "01000000000",
          },
          "tickets": selectedSeats.map((sn) => {
            "trip_id": tripId,
            "trip_route_line_id": routeLineIdFinal,
            "from_location_id": locationId ?? "",
            "to_location_id": toLocationId ?? "",
            "seat_number": sn.toString(),
            "seat_type_id": seatMap[sn.toString()] ?? '1'
          }).toList()
        };

        final createRes = await createPendingOrder(pendingOrderPayload);
        final orderId = createRes['order_id'];
        print("🔵 BlueBus order created: $orderId");

        if (payLater) {
          bluebusSuccess = true;
        } else {
          final payRes = await payOrder({"order_id": orderId});
          if (payRes['status'] == true) {
            bluebusSuccess = true;
          }
        }
      } else {
        bluebusSuccess = true;
      }

      if (bluebusSuccess) {
        await FirebaseDatabase.instance
            .ref('users/$uid/upcomingTrips')
            .push()
            .set({
          'busNumber': busNumber,
          'from': from,
          'to': to,
          'date': date,
          'departureTime': departureTime,
          'company': company,
          'seats': selectedSeats,
          'total': totalAmount,
          'paid': !payLater,
        });

        final seatPath = 'bookedSeats/${busNumber}_$date';
        final bookedRef = FirebaseDatabase.instance.ref(seatPath);
        for (final seat in selectedSeats) {
          await bookedRef.child(seat.toString()).set(true);
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Booking confirmed 🚌')));
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('BlueBus payment failed')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Booking error: $e')));
      }
    }
  }

  static Future<Map<String, dynamic>> createPendingOrder(
      Map<String, dynamic> payload) async {
    final uri = Uri.parse('$baseUrl/create-pending-order');

    try {
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        print('✅ Pending order created: $json');
        return json;
      } else {
        print('❌ Create order failed with ${res.statusCode}: ${res.body}');
        throw Exception('Create order failed – ${res.body}');
      }
    } catch (e) {
      print('❌ Exception in createPendingOrder: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> payOrder(Map<String, dynamic> payload) async {
    final uri = Uri.parse('$baseUrl/pay-order');

    try {
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        print('✅ Payment response: $json');
        return json;
      } else {
        print('❌ Pay order failed with ${res.statusCode}: ${res.body}');
        throw Exception('Pay order failed – ${res.body}');
      }
    } catch (e) {
      print('❌ Exception in payOrder: $e');
      rethrow;
    }
  }

  static Map<String,String> _seatToType(Map<String,dynamic> json) {
    final map = <String,String>{};
    if (json['unReservedSeat'] is! List) return map;
    final list = json['unReservedSeat'] as List;
    for (final block in list) {
      final typeId = block['id'].toString();
      for (final sn in block['seats_numbers']) {
        map[sn.toString()] = typeId;
      }
    }
    return map;
  }

  String _niceTime(String raw) =>
      raw.contains('T') ? raw.split('T').last.substring(0,5) : raw;
}
