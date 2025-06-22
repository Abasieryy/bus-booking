import 'package:flutter/material.dart';

class Restaurant {
  final String name;
  final String? phone;
  final String imageUrl;
  final String address;
  final String description;

  const Restaurant({
    required this.name,
    this.phone,
    required this.imageUrl,
    required this.address,
    required this.description,
  });
}

class ElTorServicesScreen extends StatelessWidget {
  const ElTorServicesScreen({super.key});

  // Temporary hard-coded list; in production you could load this from Firebase or a REST endpoint.
  List<Restaurant> get _restaurants => const [
    Restaurant(
      name: 'مطعم مندي جبل الطور',
      phone: '010 06445905',
      imageUrl: '',
      address: 'El Tor, South Sinai Governorate 46511',
      description: 'Meat-dish restaurant known for traditional Mandhi. Open 24 hours.'
    ),
    Restaurant(
      name: 'Solo',
      phone: null,
      imageUrl: '',
      address: 'El Tor, South Sinai Governorate',
      description: 'Small cosy restaurant offering dine-in and takeaway.'
    ),
    Restaurant(
      name: 'اسماك مكة',
      phone: '010 28041508',
      imageUrl: '',
      address: '7J3P+J6C, El Tor, South Sinai',
      description: 'Popular fish restaurant, fresh seafood every day.'
    ),
    Restaurant(
      name: 'حواوشي بلال',
      phone: '011 44381650',
      imageUrl: '',
      address: '6JWF+4WX, El Tor, South Sinai',
      description: 'Fast food specialising in Hawawshi, open late.'
    ),
    Restaurant(
      name: 'Solo cafe',
      phone: '015 55035915',
      imageUrl: '',
      address: 'El Tor, South Sinai Governorate 46512',
      description: 'Fast food & cafe, open 24 hours.'
    ),
    Restaurant(
      name: 'El Qenawy Restaurant',
      phone: '010 27584999',
      imageUrl: '',
      address: 'El Tor, South Sinai Governorate 8701032',
      description: 'Family restaurant with grills and takeaway service.'
    ),
    Restaurant(
      name: 'تومية',
      phone: '010 97200428',
      imageUrl: '',
      address: 'El Wadi, El Tor',
      description: 'Fast food stand well-known for Shawarma and fries.'
    ),
    Restaurant(
      name: 'Hadramout restaurant',
      phone: '010 22409537',
      imageUrl: '',
      address: '8701320, قسم الطور, 7J29+Q92, South Sinai',
      description: 'Family-friendly Yemeni cuisine, dine-in, takeaway, delivery.'
    ),
    Restaurant(
      name: 'القليوبي',
      phone: '010 10214909',
      imageUrl: '',
      address: 'gamal abdelnaser street, El Tor',
      description: 'Bakery & sweets with dine-in, takeaway, delivery.'
    ),
    Restaurant(
      name: 'مطعم اسماك البدري',
      phone: '010 05438907',
      imageUrl: '',
      address: '6JRJ+R6F, El Tor',
      description: 'Seafood restaurant, open 24 hours.'
    ),
    Restaurant(
      name: 'Al fanar beach',
      phone: null,
      imageUrl: '',
      address: '6JO4+8C, El Tor',
      description: 'Beach restaurant offering dine-in and takeaway.'
    ),
    Restaurant(
      name: 'Abu Ali Restaurant',
      phone: '010 23030013',
      imageUrl: '',
      address: 'El Tor, main road',
      description: 'Famous falafel restaurant open 24 hours.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('El Tor Restaurants'),
        backgroundColor: const Color(0xFF2E8B57),
      ),
      body: ListView.separated(
        itemCount: _restaurants.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final r = _restaurants[index];
          return ListTile(
            leading: const Icon(Icons.restaurant, size: 32, color: Color(0xFF2E8B57)),
            title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.address, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(r.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                if (r.phone != null) Text(r.phone!),
              ],
            ),
          );
        },
      ),
    );
  }
} 