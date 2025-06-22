class BlueBusTrip {
  final String tripId;
  final String fromCity;
  final String toCity;
  final String departureTime;
  final String price;
  final String uuid;
  final String fromLocationId;
  final String toLocationId;
  final String tripRouteLineId;

  BlueBusTrip({
    required this.tripId,
    required this.fromCity,
    required this.toCity,
    required this.departureTime,
    required this.price,
    required this.uuid,
    required this.fromLocationId,
    required this.toLocationId,
    required this.tripRouteLineId,
  });

  factory BlueBusTrip.fromJson(Map<String, dynamic> json) {
    String tryKeys(List<String> keys) {
      for (final k in keys) {
        if (json.containsKey(k) && json[k] != null && json[k].toString().isNotEmpty) {
          return json[k].toString();
        }
      }
      return '';
    }

    return BlueBusTrip(
      tripId: tryKeys(['id', 'trip_id', 'tripId']),
      fromCity: tryKeys(['from_city_name', 'from_city', 'from_city_name_en', 'from_city_name_ar', 'fromCityName']),
      toCity: tryKeys(['to_city_name', 'to_city', 'to_city_name_en', 'to_city_name_ar', 'toCityName']),
      departureTime: tryKeys(['departure_time', 'time', 'depart_time', 'start_time']) == ''
          ? '${tryKeys(['date'])} ${tryKeys(['time'])}'
          : tryKeys(['departure_time', 'time', 'depart_time', 'start_time']),
      price: () {
        final p = tryKeys([
          'price',
          'trip_price',
          'seat_price',
          'net_price',
          'net_fees',
          'cost'
        ]);
        if (p.isNotEmpty) return p;

        // Fallback: get min price from available_seats list
        if (json['available_seats'] is Map) {
          final av = json['available_seats'] as Map;
          if (av['unReservedSeat'] is List && (av['unReservedSeat'] as List).isNotEmpty) {
            final first = (av['unReservedSeat'] as List).first;
            if (first['price'] != null) return first['price'].toString();
          }
        }
        return '0';
      }(),
      uuid: tryKeys(['uuid', 'trip_uuid']),
      fromLocationId: tryKeys(['from_location_id', 'fromLocationId']),
      toLocationId: tryKeys(['to_location_id', 'toLocationId']),
      tripRouteLineId: () {
        // First: simple keys at root level
        String id = tryKeys([
          'trip_route_line_id',
          'tripRouteLineId',
          'route_line_id',
          'trip_route_id'
        ]);
        if (id.isNotEmpty) return id;

        // Legacy key list
        if (json['trip_route_lines'] is List && (json['trip_route_lines'] as List).isNotEmpty) {
          final List<dynamic> lines = json['trip_route_lines'] as List;
          String matched = _matchRoute(lines, json);
          if (matched.isNotEmpty) return matched;
        }

        // New key used by current API
        if (json['route_lines'] is List && (json['route_lines'] as List).isNotEmpty) {
          final List<dynamic> lines = json['route_lines'] as List;
          String matched = _matchRoute(lines, json);
          if (matched.isNotEmpty) return matched;
        }
        return '';
      }(),
    );
  }

  // Helper to find best route line id
  static String _matchRoute(List<dynamic> lines, Map<String, dynamic> parent) {
    String parentFrom = parent['from_location_id']?.toString() ?? '';
    String parentTo   = parent['to_location_id']?.toString() ?? '';

    for (final l in lines) {
      if (l is Map) {
        // Match by location id if available, otherwise by city id
        final fromLoc = l['from_location_id']?.toString() ?? l['from_city_id']?.toString() ?? '';
        final toLoc   = l['to_location_id']?.toString() ?? l['to_city_id']?.toString() ?? '';

        if (parentFrom.isNotEmpty && parentTo.isNotEmpty) {
          if (fromLoc == parentFrom && toLoc == parentTo) {
            return l['id']?.toString() ?? l['uuid']?.toString() ?? '';
          }
        }
      }
    }

    // fallback to first route line id
    final first = lines.first;
    if (first is Map) {
      return first['id']?.toString() ?? first['uuid']?.toString() ?? '';
    }
    return '';
  }
}
