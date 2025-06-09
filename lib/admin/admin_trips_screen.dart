// lib/screens/admin_trips_screen.dart

import 'package:flutter/material.dart';
import 'package:bus_booking/core/bus_trip.dart';
import 'package:bus_booking/admin/admin_trip_service.dart';
class AdminTripsScreen extends StatefulWidget {
  final String company;
  const AdminTripsScreen({Key? key, required this.company}) : super(key: key);

  @override
  _AdminTripsScreenState createState() => _AdminTripsScreenState();
}

class _AdminTripsScreenState extends State<AdminTripsScreen> {
  final _service = AdminTripService();
  List<BusTrip> _trips = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    final trips = await _service.fetchAll(widget.company);
    setState(() {
      _trips = trips;
      _loading = false;
    });
  }

  void _deleteTrip(String tripId) async {
    await _service.delete(widget.company, tripId);
    _loadTrips();
  }

  void _showEditDialog(BusTrip? trip) {
    final _fromCtrl = TextEditingController(text: trip?.from ?? '');
    final _toCtrl = TextEditingController(text: trip?.to ?? '');
    final _timeCtrl = TextEditingController(text: trip?.departureTime ?? '');
    final _priceCtrl = TextEditingController(text: trip?.price.toString() ?? '');
    final _seatsCtrl = TextEditingController(text: trip?.seatsAvailable.toString() ?? '');
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(trip == null ? 'Add Trip' : 'Edit Trip'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _fromCtrl,
                  decoration: InputDecoration(labelText: 'From'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _toCtrl,
                  decoration: InputDecoration(labelText: 'To'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _timeCtrl,
                  decoration: InputDecoration(labelText: 'Departure (ISO8601)'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _priceCtrl,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || int.tryParse(v) == null ? 'Number' : null,
                ),
                TextFormField(
                  controller: _seatsCtrl,
                  decoration: InputDecoration(labelText: 'Seats'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || int.tryParse(v) == null ? 'Number' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;
              final newTrip = BusTrip(
                id: trip?.id,
                from: _fromCtrl.text.trim(),
                to: _toCtrl.text.trim(),
                departureTime: _timeCtrl.text.trim(),
                price: int.parse(_priceCtrl.text),
                seatsAvailable: int.parse(_seatsCtrl.text),
                company: widget.company,

              );
              if (trip == null) {
                await _service.add(widget.company, newTrip);
              } else {
                await _service.update(widget.company, newTrip);
              }
              Navigator.pop(context);
              _loadTrips();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Trips — ${widget.company}'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showEditDialog(null),
          )
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _trips.length,
        itemBuilder: (context, i) {
          final t = _trips[i];
          return ListTile(
            title: Text('${t.from} → ${t.to}'),
            subtitle: Text('${t.departureTime} · EGP ${t.price} · Seats: ${t.seatsAvailable}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showEditDialog(t),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteTrip(t.id!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
