import 'package:bus_booking/models/bluebus_trip.dart';

class BusTrip {
  final String? id;
  final String from;
  final String to;
  final int? fromCityId;
  final int? toCityId;
  final int? fromLocationId;
  final int? toLocationId;
  final String departureTime;
  final int price;
  final int seatsAvailable;
  final String company;
  final String? locationId;
  final String? tripUuid;
  final String? tripRouteLineId;

  BusTrip({
    required this.id,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.price,
    required this.seatsAvailable,
    required this.company,
    this.fromCityId,
    this.toCityId,
    this.fromLocationId,
    this.toLocationId,
    this.locationId,
    this.tripUuid,
    this.tripRouteLineId,
  });

  String get dateOnly {
    if (departureTime.contains('T')) {
      return departureTime.split('T').first;
    }
    return departureTime.split(' ').first;
  }

  String get timeOnly {
    try {
      if (departureTime.contains('T')) {
        final dt = DateTime.parse(departureTime).toLocal();
        return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
      return departureTime.split(' ').length > 1 ? departureTime.split(' ').last : departureTime;
    } catch (_) {
      return departureTime;
    }
  }

  factory BusTrip.fromMap(Map<dynamic, dynamic> json, String id, String company) {
    return BusTrip(
      id: id,
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
      fromCityId: int.tryParse(json['fromCityId']?.toString() ?? '') ?? -1,
      toCityId: int.tryParse(json['toCityId']?.toString() ?? '') ?? -1,
      fromLocationId: int.tryParse(json['fromLocationId']?.toString() ?? '') ?? -1,
      toLocationId: int.tryParse(json['toLocationId']?.toString() ?? '') ?? -1,
      departureTime: json['departureTime']?.toString() ?? '',
      price: int.tryParse(json['price']?.toString() ?? '') ?? 0,
      seatsAvailable: int.tryParse(json['seatsAvailable']?.toString() ?? '') ?? 40,
      company: company,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'fromCityId': fromCityId,
      'toCityId': toCityId,
      'fromLocationId': fromLocationId,
      'toLocationId': toLocationId,
      'departureTime': departureTime,
      'price': price,
      'seatsAvailable': seatsAvailable,
      'company': company,
    };
  }

  factory BusTrip.fromBlueBusModel(BlueBusTrip trip) {
    return BusTrip(
      id: trip.tripId,
      from: trip.fromCity,
      to: trip.toCity,
      departureTime: trip.departureTime,
      price: int.tryParse(trip.price) ?? 0,
      seatsAvailable: 40,
      company: 'BlueBus',
      locationId: trip.fromLocationId,
      tripUuid: trip.uuid,
      tripRouteLineId: trip.tripRouteLineId,
      fromLocationId: int.tryParse(trip.fromLocationId),
      toLocationId: int.tryParse(trip.toLocationId),
    );
  }

  BusTrip copyWith({
    String? id,
    String? from,
    String? to,
    int? fromCityId,
    int? toCityId,
    int? fromLocationId,
    int? toLocationId,
    String? departureTime,
    int? price,
    int? seatsAvailable,
    String? company,
    String? locationId,
    String? tripUuid,
    String? tripRouteLineId,
  }) {
    return BusTrip(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      fromCityId: fromCityId ?? this.fromCityId,
      toCityId: toCityId ?? this.toCityId,
      fromLocationId: fromLocationId ?? this.fromLocationId,
      toLocationId: toLocationId ?? this.toLocationId,
      departureTime: departureTime ?? this.departureTime,
      price: price ?? this.price,
      seatsAvailable: seatsAvailable ?? this.seatsAvailable,
      company: company ?? this.company,
      locationId: locationId ?? this.locationId,
      tripUuid: tripUuid ?? this.tripUuid,
      tripRouteLineId: tripRouteLineId ?? this.tripRouteLineId,
    );
  }
}
