import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'rent_list_page.dart';

class RentTimerPage extends StatefulWidget {
  final List<RentItem> rentedItems;

  RentTimerPage({required this.rentedItems});

  @override
  _RentTimerPageState createState() => _RentTimerPageState();
}

class _RentTimerPageState extends State<RentTimerPage> {
  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();
    refreshTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now().add(const Duration(minutes:10));
    String formattedDate = DateFormat('kk:mm').format(now);
    return Scaffold(
      appBar: AppBar(title: Text('Active Rentals')),
      body: ListView.builder(
        itemCount: widget.rentedItems.length,
        itemBuilder: (context, index) {
          final item = widget.rentedItems[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('End Time: ${formattedDate} - ${item.remainingTime ~/ 60}:${(item.remainingTime % 60).toString().padLeft(2, '0')}'),
            tileColor: item.remainingTime == 0 ? Colors.red : Colors.white,
          );
        },
      ),
    );
  }
}