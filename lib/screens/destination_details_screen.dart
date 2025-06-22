import 'package:flutter/material.dart';

class DestinationDetailsScreen extends StatelessWidget {
  final String title;
  final String imageUrl;

  const DestinationDetailsScreen({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  String _getDestinationDescription(String title) {
    switch (title) {
      case 'Pyramids of Giza':
        return '''The Great Pyramids of Giza are the oldest and largest of the three pyramids in the Giza pyramid complex. Built during the Fourth Dynasty of the Old Kingdom of Egypt, they are the only remaining wonder of the ancient world.

The complex includes the Great Pyramid of Khufu (Cheops), the Pyramid of Khafre (Chephren), and the Pyramid of Menkaure (Mycerinus), along with their associated pyramid complexes and the Great Sphinx of Giza.

The Great Pyramid, built for Pharaoh Khufu, was the tallest man-made structure in the world for over 3,800 years. It was constructed using an estimated 2.3 million stone blocks, each weighing between 2.5 and 15 tons.''';

      case 'Luxor Temple':
        return '''Luxor Temple is a large Ancient Egyptian temple complex located on the east bank of the Nile River in the city of Luxor. It was constructed approximately 1400 BCE and was dedicated to the rejuvenation of kingship.

The temple was built by Amenhotep III and completed by Tutankhamun and Horemheb, with additions by Ramses II. It was the center of the most important festival in ancient Egypt - the annual Opet Festival.

The temple's architecture is characterized by its massive columns, intricate carvings, and the famous avenue of sphinxes that once connected it to the Karnak Temple.''';

      case 'Abu Simbel':
        return '''The Abu Simbel temples are two massive rock temples at Abu Simbel, a village in Nubia, southern Egypt. They were constructed during the reign of Pharaoh Ramesses II in the 13th century BCE.

The twin temples were carved out of the mountainside during Ramesses II's reign to commemorate his victory at the Battle of Kadesh and to intimidate his Nubian neighbors.

The larger temple is dedicated to Ra-Horakhty, Ptah, and Amun, while the smaller temple is dedicated to the goddess Hathor and Ramesses II's wife, Nefertari. The temples were relocated in 1968 to avoid being submerged during the creation of Lake Nasser.''';

      case 'Karnak Temple':
        return '''The Karnak Temple Complex is the largest ancient religious site in the world. It is located in Luxor, Egypt, and was built over a period of 2,000 years.

The complex consists of four main parts, of which only the largest is currently open to the public. The term Karnak often refers to the main temple precinct of the god Amun-Re.

The temple complex includes the Great Hypostyle Hall, which contains 134 massive columns arranged in 16 rows. The hall covers an area of 50,000 square feet and is considered one of the most impressive architectural achievements of ancient Egypt.''';

      case 'Valley of Kings':
        return '''The Valley of the Kings is a valley in Egypt where, for a period of nearly 500 years from the 16th to 11th century BCE, rock-cut tombs were excavated for the pharaohs and powerful nobles of the New Kingdom.

The valley contains 63 tombs and chambers, ranging in size from a simple pit to a complex tomb with over 120 chambers. The royal tombs are decorated with scenes from Egyptian mythology and give clues to the beliefs and funerary rituals of the period.

The most famous tomb is that of Tutankhamun, discovered by Howard Carter in 1922. The valley has been a major focus of archaeological and egyptological exploration since the end of the 18th century.''';

      case 'Aswan':
        return '''Aswan is a city in southern Egypt, located on the east bank of the Nile River. It is known for its beautiful Nile Valley scenery, significant archaeological sites, and peaceful atmosphere.

The city is home to the Aswan High Dam, which created Lake Nasser, and the Unfinished Obelisk, which would have been the largest piece of stone ever worked by the ancient Egyptians.

Aswan is also famous for its Nubian culture, colorful markets, and the Philae Temple, which was relocated to Agilkia Island after the construction of the High Dam.''';

      case 'Alexandria':
        return '''Alexandria is the second-largest city in Egypt and a major economic center. Founded by Alexander the Great in 331 BCE, it was the capital of Egypt for nearly 1,000 years.

The city was home to the Lighthouse of Alexandria, one of the Seven Wonders of the Ancient World, and the Great Library of Alexandria, the largest library of the ancient world.

Today, Alexandria is known for its Mediterranean atmosphere, beautiful beaches, and important historical sites such as the Catacombs of Kom el Shoqafa, Pompey's Pillar, and the modern Bibliotheca Alexandrina.''';

      case 'Cairo':
        return '''Cairo is the capital and largest city of Egypt. It is the country's political, cultural, and economic center, and one of the largest cities in Africa and the Middle East.

The city is home to the Egyptian Museum, which houses the world's largest collection of ancient Egyptian artifacts, and the historic Islamic Cairo district, which contains hundreds of mosques, madrasas, and other monuments from various periods of Islamic history.

Modern Cairo is a vibrant metropolis that combines ancient history with contemporary life, featuring world-class restaurants, shopping districts, and cultural institutions.''';

      case 'EL Tor':
        return '''El Tor (also spelled Al-Tur) is a coastal city in South Sinai, Egypt. Known for its serene Red Sea shoreline and warm hospitality, El Tor is the administrative capital of South Sinai Governorate and a convenient stop-over for travelers heading to Sharm El Sheikh or St Catherine. The city offers fresh seafood restaurants, local cafés, and quiet beaches perfect for relaxation.''';

      default:
        return 'No description available for this destination.';
    }
  }

  List<Map<String, String?>> _elTorRestaurants() => [
        {
          'name': 'مطعم مندي جبل الطور',
          'phone': '010 06445905',
          'image': 'https://i.imgur.com/OQqfV4R.jpg',
          'address': 'El Tor, South Sinai',
        },
        {
          'name': 'Solo',
          'phone': null,
          'image': 'https://i.imgur.com/1D8K8Rm.jpg',
          'address': 'El Tor, South Sinai',
        },
        {
          'name': 'اسماك مكة',
          'phone': '010 28041508',
          'image': 'https://i.imgur.com/NV8uLro.jpg',
          'address': '7J3P+J6C, El Tor',
        },
        {
          'name': 'حواوشي بلال',
          'phone': '011 44381650',
          'image': 'https://i.imgur.com/EDqUqkU.jpg',
          'address': '6JWF+4WX, El Tor',
        },
        {
          'name': 'Solo cafe',
          'phone': '015 55035915',
          'image': 'https://i.imgur.com/6q4rhS8.jpg',
          'address': 'El Tor, South Sinai',
        },
        {
          'name': 'El Qenawy Restaurant',
          'phone': '010 27584999',
          'image': 'https://i.imgur.com/7bLhbrG.jpg',
          'address': 'El Tor, South Sinai',
        },
        {
          'name': 'تومية',
          'phone': '010 97200428',
          'image': 'https://i.imgur.com/DZmB1Zt.jpg',
          'address': 'El Wadi, El Tor',
        },
        {
          'name': 'Hadramout restaurant',
          'phone': '010 22409537',
          'image': 'https://i.imgur.com/CvnvqQ7.jpg',
          'address': '7J29+Q92, El Tor',
        },
        {
          'name': 'القليوبي',
          'phone': '010 10214909',
          'image': 'https://i.imgur.com/qiTEGMI.jpg',
          'address': 'gamal abdelnaser st., El Tor',
        },
        {
          'name': 'مطعم اسماك البدري',
          'phone': '010 05438907',
          'image': 'https://i.imgur.com/3Z6bTbk.jpg',
          'address': '6JRJ+R6F, El Tor',
        },
        {
          'name': 'Al fanar beach',
          'phone': null,
          'image': 'https://i.imgur.com/oxVTm58.jpg',
          'address': '6JO4+8C, El Tor',
        },
        {
          'name': 'Abu Ali Restaurant',
          'phone': '010 23030013',
          'image': 'https://i.imgur.com/zM5XlKi.jpg',
          'address': 'Main road, El Tor',
        },
      ];

  List<Map<String, String?>> _elTorHotels() => [
        {
          'name': 'Delmon Hotel',
          'phone': '069 3771060',
          'image': 'https://i.imgur.com/Yq4j3fV.jpg',
          'address': 'El Tor, South Sinai',
          'price': 'EGP 890',
        },
        {
          'name': 'Moses Bay Resort - Magdolina',
          'phone': '010 23010348',
          'image': 'https://i.imgur.com/7Y5DJRg.jpg',
          'address': '6JM4+FRJ, El Corniche Rd, El Tor',
          'price': '-',
        },
      ];

  List<Map<String, String?>> _elTorHospitals() => [
        {
          'name': 'South Sinai Hospital',
          'phone': '012 20003533',
          'image': 'https://i.imgur.com/PDk2yxp.jpg',
          'address': '10 Ras Kennedy El-Salam, El Tor',
        },
        {
          'name': 'El Tor General Hospital (Outpatient Clinic)',
          'phone': '069 3773235',
          'image': 'https://i.imgur.com/kLjWNKI.jpg',
          'address': '6JWC+VQ4, El Tor',
        },
        {
          'name': 'Markaz Sehi Al Zahraa',
          'phone': null,
          'image': 'https://i.imgur.com/haurbZH.jpg',
          'address': '6JWQ+X2X, El Tor',
        },
        {
          'name': 'Fayrouz Medical Complex',
          'phone': null,
          'image': 'https://i.imgur.com/j9D4rXY.jpg',
          'address': 'ElNasr Neighborhood, El Tor',
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF101418), Color(0xFF14532D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 26,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageUrl.startsWith('http')
                      ? NetworkImage(imageUrl)
                      : AssetImage(imageUrl) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E8B57),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getDestinationDescription(title),
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                  if (title == 'EL Tor') ...[
                    const SizedBox(height: 28),
                    const Text(
                      'Popular Restaurants',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF101418),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _elTorRestaurants().length,
                      itemBuilder: (context, index) {
                        final r = _elTorRestaurants()[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://source.unsplash.com/seed/restaurant$index/80x80?restaurant,food',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.restaurant, color: Colors.white70),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r['name']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                                    Text(r['address']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    if (r['phone'] != null)
                                      Text(r['phone']!, style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // ─────── Hotels ──────────────────────────
                    const SizedBox(height: 28),
                    const Text(
                      'Hotels',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF101418),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _elTorHotels().length,
                      itemBuilder: (context, index) {
                        final h = _elTorHotels()[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://source.unsplash.com/seed/hotel$index/80x80?hotel,resort',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.hotel, color: Colors.white70),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(h['name']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                                    Text(h['address']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    if (h['phone'] != null)
                                      Text(h['phone']!, style: const TextStyle(fontSize: 12)),
                                    if (h['price'] != null && h['price']!.isNotEmpty)
                                      Text(h['price']!, style: const TextStyle(fontSize: 12, color: Color(0xFF2E8B57))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // ─────── Hospitals ───────────────────────
                    const SizedBox(height: 28),
                    const Text(
                      'Hospitals & Clinics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF101418),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _elTorHospitals().length,
                      itemBuilder: (context, index) {
                        final m = _elTorHospitals()[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://source.unsplash.com/seed/hospital$index/80x80?hospital,clinic',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.local_hospital, color: Colors.white70),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(m['name']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                                    Text(m['address']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    if (m['phone'] != null)
                                      Text(m['phone']!, style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
