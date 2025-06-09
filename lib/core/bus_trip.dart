class BusTrip {
  final String? id;
  final String from;
  final String to;
  final String departureTime;
  final int price;
  final int seatsAvailable;
  final String company;

  BusTrip({
    this.id,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.price,
    required this.seatsAvailable,
    required this.company,
  });

  String get dateOnly {
    return departureTime.split('T')[0];
  }

  factory BusTrip.fromMap(Map<dynamic, dynamic> map, String? id, String company) {
    return BusTrip(
      id: id,
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      departureTime: map['departureTime'] ?? '',
      price: int.tryParse(map['price'].toString()) ?? 0,
      seatsAvailable: int.tryParse(map['seatsAvailable'].toString()) ?? 0,
      company: company,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'departureTime': departureTime,
      'price': price,
      'seatsAvailable': seatsAvailable,
      'company': company,
    };
  }
}
