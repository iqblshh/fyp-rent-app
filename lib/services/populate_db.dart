import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fyp_iqbal/models/itemtype.dart';
import 'package:fyp_iqbal/models/rentitem.dart';
import 'package:fyp_iqbal/models/rental.dart';
import 'package:fyp_iqbal/services/database_service.dart';

class PopulateDbPage extends StatefulWidget {
  const PopulateDbPage({super.key});

  @override
  State<PopulateDbPage> createState() => _PopulateDbPageState();
}

class _PopulateDbPageState extends State<PopulateDbPage> {
  bool _isLoading = false;
  String _result = "";

  Future<void> _populateSampleData() async {
    setState(() {
      _isLoading = true;
      _result = "";
    });

    final db = DatabaseService();

    // 1. Insert 3 item types
    final itemTypes = [
      ItemType(id: 1, name: 'apple', timer: 10, price: 10),
      ItemType(id: 2, name: 'android', timer: 15, price: 15),
      ItemType(id: 3, name: 'windows', timer: 20, price: 20),
    ];
    for (final itemType in itemTypes) {
      await db.insertItemType(itemType);
    }

    // 2. Insert 6 rent items (2 for each type)
    final rentItems = [
      RentItem(id: 1, name: 'Apple Watch', itemtypeId: 1),
      RentItem(id: 2, name: 'Apple iPad', itemtypeId: 1),
      RentItem(id: 3, name: 'Android Phone', itemtypeId: 2),
      RentItem(id: 4, name: 'Android Tablet', itemtypeId: 2),
      RentItem(id: 5, name: 'Windows Laptop', itemtypeId: 3),
      RentItem(id: 6, name: 'Windows Surface', itemtypeId: 3),
    ];
    for (final rentItem in rentItems) {
      await db.insertRentItem(rentItem);
    }

    // 3. Insert 50 rentals with random data
    final random = Random();
    final now = DateTime.now();
    final dateList = List.generate(4, (i) => now.subtract(Duration(days: 3 - i)));
    for (int i = 0; i < 50; i++) {
      final rentItem = rentItems[random.nextInt(rentItems.length)];
      final itemType = itemTypes.firstWhere((t) => t.id == rentItem.itemtypeId);

      final date = dateList[random.nextInt(dateList.length)];
      final dateStr = DateFormat('dd/MM/yyyy').format(date);

      final startHour = 18 + random.nextInt(5); // 18,19,20,21,22
      final startMinute = random.nextInt(2) * 30; // 0 or 30
      final statime = '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}';

      final startDT = DateTime(date.year, date.month, date.day, startHour, startMinute);
      final endDT = startDT.add(Duration(minutes: itemType.timer));
      final endHour = endDT.hour > 23 ? 23 : endDT.hour;
      final endMinute = endDT.hour > 23 ? 0 : endDT.minute;
      final endtime = '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';

      final lateMinutes = -5 + random.nextInt(16); // -5 to +10
      final lateDT = endDT.add(Duration(minutes: lateMinutes));
      final latetime = '${lateDT.hour.toString().padLeft(2, '0')}:${lateDT.minute.toString().padLeft(2, '0')}';

      await db.insertRental(Rental(
        id: null,
        rentitemId: rentItem.id!,
        itemType: itemType.name,
        itemName: rentItem.name,
        statime: statime,
        endtime: endtime,
        latetime: latetime,
        date: dateStr,
        price: itemType.price,
        paid: 1,
        status: 1,
      ));
    }

    setState(() {
      _isLoading = false;
      _result = "Database populated with sample data!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Populate Database'),
        backgroundColor: const Color.fromARGB(255, 137, 164, 209),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isLoading ? null : _populateSampleData,
                child: const Text('Populate Sample Data'),
              ),
              const SizedBox(height: 24),
              if (_isLoading) const CircularProgressIndicator(),
              if (_result.isNotEmpty) Text(_result, style: const TextStyle(color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }
}