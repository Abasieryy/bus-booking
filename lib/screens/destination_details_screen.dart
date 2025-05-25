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

      default:
        return 'No description available for this destination.';
    }
  }

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
                  image: NetworkImage(imageUrl),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
