// lib/helpers/order_mapper.dart

import 'package:bus_booking/core/bus_trip.dart';

Map<String, dynamic> mapBusTripToBlueBusOrder({
  required BusTrip trip,
  required List<String> selectedSeatNumbers,
  required String clientName,
  required String mobile,
  required String email,
  required String nationalId,
}) {
  return {
    'trip_id': trip.id ?? '',
    'seats': selectedSeatNumbers,
    'mobile': mobile,
    'email': email,
    'national_id': nationalId,
    'client_name': clientName,
    // Add any extra required fields from Blue Bus API here:
    // e.g. 'coupon': '',
    // e.g. 'gender': 'male',
    // e.g. 'payment_type': 'card',
  };
}
