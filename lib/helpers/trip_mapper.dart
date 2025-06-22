// lib/helpers/trip_mapper.dart
import 'package:bus_booking/core/bus_trip.dart';
import 'package:bus_booking/services/bluebus_service.dart';
import 'package:bus_booking/models/bluebus_trip.dart';
/// Converts a list of BlueBusTrip models into your unified BusTrip model.
/// This is helpful for rendering Blue Bus trips alongside Firebase trips.
List<BusTrip> mapBlueBusTripsToBusTrips(List<BlueBusTrip> blueBusTrips) {
  return blueBusTrips.map((trip) {
    return BusTrip(
      id: trip.tripId,
      from: trip.fromCity,
      to: trip.toCity,
      departureTime: trip.departureTime,
      price: int.tryParse(trip.price) ?? 0,
      seatsAvailable: 40, // You can override this dynamically if needed
      company: 'BlueBus',
      locationId: trip.fromLocationId?.toString(),
      tripUuid: trip.uuid,
    );
  }).toList();
}
