import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bus_booking/profile/profile_screen.dart';
import 'package:bus_booking/booking/search_results_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:bus_booking/screens/destination_details_screen.dart';
import 'package:bus_booking/helpers/city_mapper.dart';
import 'package:bus_booking/core/user_trip_service.dart';
import 'package:bus_booking/screens/el_tor_services_screen.dart';

class MainPage extends StatefulWidget {
  final int initialIndex;
  const MainPage({super.key, this.initialIndex = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  DateTime? _selectedDate;
  late int _selectedIndex;
  String? _selectedFromCity;
  String? _selectedFromLocation;
  String? _selectedToCity;
  String? _selectedToLocation;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  InputDecoration _dropdownDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2E8B57)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2E8B57), width: 2),
      ),
    );
  }

  final List<String> _egyptianCities = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Sharm El Sheikh',
    'Hurghada',
    'Luxor',
    'Aswan',
    'Port Said',
    'Suez',
    'Dahab',
    'Marsa Alam',
    'Taba',
    'El Gouna',
    'Safaga',
    'Marsa Matrouh',
    'El Tor',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildMainContent();
      case 1:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
                children: [
                  _buildServiceCard(
                    imageUrl: 'assets/images/dahab1.jfif',
                    title: 'Dahab',
                    onTap: () {},
                  ),
                  _buildServiceCard(
                    imageUrl: 'assets/images/luxor1.jpg',
                    title: 'Luxor',
                    onTap: () {},
                  ),
                  _buildServiceCard(
                    imageUrl: 'assets/images/sharm1.jpg',
                    title: 'Sharm El Sheikh',
                    onTap: () {},
                  ),
                  _buildServiceCard(
                    imageUrl: 'assets/images/Hurghada1.jpg',
                    title: 'Hurghada',
                    onTap: () {},
                  ),
                  _buildServiceCard(
                    imageUrl: 'assets/images/eltor.jpg',
                    title: 'EL Tor',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ElTorServicesScreen(),
                        ),
                      );
                    },
                  ),
                  _buildServiceCard(
                    imageUrl: 'assets/images/aswan1.jpg',
                    title: 'Aswan',
                    onTap: () {},
                  ),
                  _buildServiceCard(
                    imageUrl: 'assets/images/alex1.webp',
                    title: 'Alexandria',
                    onTap: () {},
                  ),
                  _buildServiceCard(
                    imageUrl: 'assets/images/cairo1.jfif',
                    title: 'Cairo',
                    onTap: () {},
                  ),
                  _buildServiceCard(
                    imageUrl: 'assets/images/portsaid1.webp',
                    title: 'PortSaid',
                    onTap: () {},
                  ),
                  _buildServiceCard(
                    imageUrl: 'assets/images/marsa1.webp',
                    title: 'Marsa Matrouh',
                    onTap: () {},
                  ),
                  _buildServiceCard(
                    imageUrl: 'assets/images/sudr1.jpg',
                    title: 'Ras Sudr',
                    onTap: () {},
                  ),
                  _buildServiceCard(
                    imageUrl: 'assets/images/qena1.jpg',
                    title: 'Qena',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        );
      case 2:
        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const TabBar(
                  labelColor: Color(0xFF2E8B57),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Color(0xFF2E8B57),
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(text: 'ONGOING TRIPS'),
                    Tab(text: 'UPCOMING TRIPS'),
                    Tab(text: 'PAST TRIPS'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildTicketList(
                      tickets: [
                        TicketData(
                          from: 'Cairo',
                          to: 'Alexandria',
                          date: 'Today, 2:30 PM',
                          status: 'In Progress',
                          statusColor: Colors.green,
                          ticketNumber: 'TKT-2024-001',
                          busNumber: 'BUS-123',
                          price: 'EGP 1,400',
                        ),
                      ],
                    ),
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: UserTripService.upcomingTrips(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final trips = snapshot.data!;
                        if (trips.isEmpty) {
                          return const Center(child: Text('No upcoming trips'));
                        }
                        final tickets = trips.map((t) => TicketData(
                          from: t['from'] ?? '-',
                          to: t['to'] ?? '-',
                          date: '${t['date'] ?? '-'} , ${t['departureTime'] ?? ''}',
                          status: 'Confirmed',
                          statusColor: Colors.blue,
                          ticketNumber: t['busNumber'] ?? '-',
                          busNumber: t['busNumber']?.toString() ?? '-',
                          price: 'EGP ${t['total'] ?? ''}',
                        )).toList();
                        return _buildTicketList(tickets: tickets);
                      },
                    ),
                    _buildTicketList(
                      tickets: [
                        TicketData(
                          from: 'Giza',
                          to: 'Luxor',
                          date: 'Dec 15, 2024',
                          status: 'Completed',
                          statusColor: Colors.grey,
                          ticketNumber: 'TKT-2024-004',
                          busNumber: 'BUS-101',
                          price: 'EGP 1,250',
                        ),
                        TicketData(
                          from: 'ElTor',
                          to: 'Alexandria',
                          date: 'Dec 10, 2024',
                          status: 'Completed',
                          statusColor: Colors.grey,
                          ticketNumber: 'TKT-2024-005',
                          busNumber: 'BUS-202',
                          price: 'EGP 1,550',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 3:
        return const ProfileScreen();
      default:
        return _buildMainContent();
    }
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/images/mainpage.jpg',
                height: 180, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // FROM
                _dropdownBlock(
                  label: 'From',
                  selectedCity: _selectedFromCity,
                  selectedLocation: _selectedFromLocation,
                  onCityChanged: (city) => setState(() {
                    _selectedFromCity = city;
                    _selectedFromLocation = null;
                  }),
                  onLocationChanged: (loc) => setState(() => _selectedFromLocation = loc),
                ),

                // TO
                _dropdownBlock(
                  label: 'To',
                  selectedCity: _selectedToCity,
                  selectedLocation: _selectedToLocation,
                  onCityChanged: (city) => setState(() {
                    _selectedToCity = city;
                    _selectedToLocation = null;
                  }),
                  onLocationChanged: (loc) => setState(() => _selectedToLocation = loc),
                ),

                const SizedBox(height: 20),
                // Date Selection
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date of Trip',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF2E8B57)),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'Select Date'
                          : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_selectedFromCity != null &&
                    _selectedFromLocation != null &&
                    _selectedToCity != null &&
                    _selectedToLocation != null &&
                    _selectedDate != null) {

                  final fromLocationId = cityLocationIdMap[_selectedFromCity!]![_selectedFromLocation!].toString();
                  final toLocationId = cityLocationIdMap[_selectedToCity!]![_selectedToLocation!].toString();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResultsScreen(
                        from: _selectedFromCity!,
                        to: _selectedToCity!,
                        date: DateFormat('MMM dd, yyyy').format(_selectedDate!),
                        fromLocationId: fromLocationId,
                        toLocationId: toLocationId,
                      ),
                    ),
                  );
                }
              },


              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color(0xFF2E8B57),
              ),
              child: const Text(
                'Search Buses',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 6),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildServiceCard(
                  imageUrl: 'assets/images/Alexandria-City-Egypt-Egypt-Tours-Portal.jpg',
                  title: 'Alexandria',
                  onTap: () {
                    setState(() {
                      _toController.text = 'Alexandria';
                    });
                  },
                ),
                const SizedBox(width: 16),
                _buildServiceCard(
                  imageUrl: 'https://images.unsplash.com/photo-1572252009286-268acec5ca0a',
                  title: 'Cairo',
                  onTap: () {
                    setState(() {
                      _toController.text = 'Cairo';
                    });
                  },
                ),
                const SizedBox(width: 16),
                _buildServiceCard(
                  imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                  title: 'Luxor',
                  onTap: () {
                    setState(() {
                      _toController.text = 'Luxor';
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E8B57),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF2D3748),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildTicketList({required List<TicketData> tickets}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return GestureDetector(
          onTap: () {
            // TODO: Navigate to ticket details
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Viewing ticket ${ticket.ticketNumber}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ticket.ticketNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E8B57),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ticket.statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          ticket.status,
                          style: TextStyle(
                            color: ticket.statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: Color(0xFF2E8B57),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        ticket.from,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Color(0xFF2E8B57),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        ticket.to,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      ticket.date,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                ticket.price,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF2E8B57),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ticket.busNumber,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Scan QR Code',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Show to bus driver',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            QrImageView(
                              data:
                              '${ticket.ticketNumber}|${ticket.busNumber}|${ticket.from}|${ticket.to}|${ticket.date}',
                              version: QrVersions.auto,
                              size: 60.0,
                              backgroundColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceCard({
    required String imageUrl,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DestinationDetailsScreen(
              title: title,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              imageUrl.startsWith('http')
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownBlock({
    required String label,
    required String? selectedCity,
    required String? selectedLocation,
    required ValueChanged<String?> onCityChanged,
    required ValueChanged<String?> onLocationChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            decoration: _dropdownDecoration('Choose $label city'),
            value: selectedCity,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF2E8B57)),
            items: cityLocationIdMap.keys
                .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                .toList(),
            onChanged: onCityChanged,
          ),

          if (selectedCity != null) ...[
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              decoration: _dropdownDecoration('Choose $label location'),
              value: selectedLocation,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF2E8B57)),
              items: cityLocationIdMap[selectedCity]!.keys
                  .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                  .toList(),
              onChanged: onLocationChanged,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    Color appBarColor;
    Color titleColor;
    IconData titleIcon;

    switch (_selectedIndex) {
      case 0:
        appBarTitle = 'Book Trip';
        appBarColor = const Color(0xFF101418);
        titleColor = Colors.white;
        titleIcon = Icons.directions_bus;
        break;
      case 1:
        appBarTitle = 'Services';
        appBarColor = const Color(0xFF101418);
        titleColor = Colors.white;
        titleIcon = Icons.miscellaneous_services;
        break;
      case 2:
        appBarTitle = 'Ticket History';
        appBarColor = const Color(0xFF101418);
        titleColor = Colors.white;
        titleIcon = Icons.history;
        break;
      case 3:
        appBarTitle = 'Profile';
        appBarColor = const Color(0xFF101418);
        titleColor = Colors.white;
        titleIcon = Icons.person;
        break;
      default:
        appBarTitle = 'Book Trip';
        appBarColor = const Color(0xFF101418);
        titleColor = Colors.white;
        titleIcon = Icons.directions_bus;
    }
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF101418), Color(0xFF2E8B57)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        titleIcon,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          appBarTitle,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedIndex == 0
                              ? 'Find and book your next bus trip'
                              : '',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: _buildBody(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF101418), Color(0xFF2E8B57)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white.withOpacity(0.5),
                backgroundColor: Colors.transparent,
                elevation: 0,
                onTap: _onItemTapped,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 11,
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 0
                            ? Colors.white.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.home, size: 24),
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 1
                            ? Colors.white.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.design_services, size: 24),
                    ),
                    label: 'Services',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 2
                            ? Colors.white.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.history, size: 24),
                    ),
                    label: 'History',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 3
                            ? Colors.white.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.person, size: 24),
                    ),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TicketData {
  final String from;
  final String to;
  final String date;
  final String status;
  final Color statusColor;
  final String ticketNumber;
  final String busNumber;
  final String price;

  TicketData({
    required this.from,
    required this.to,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.ticketNumber,
    required this.busNumber,
    required this.price,
  });
}
