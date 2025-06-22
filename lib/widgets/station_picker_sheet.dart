import 'package:flutter/material.dart';

class StationPickerSheet extends StatelessWidget {
  final Map<String, Map<String, int>> cityLocationIdMap;
  const StationPickerSheet({super.key, required this.cityLocationIdMap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Stations',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: cityLocationIdMap.entries.map((cityEntry) {
                  final city = cityEntry.key;
                  final locMap = cityEntry.value;
                  return ExpansionTile(
                    title: Text(
                      city,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    children: locMap.keys.map((loc) {
                      return ListTile(
                        title: Text(loc),
                        onTap: () => Navigator.pop(
                          context,
                          {'city': city, 'loc': loc},
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 