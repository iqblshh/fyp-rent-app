import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'create_item_page.dart';
import 'timer_page.dart';

class RentItem {
  String name;
  double price;
  int duration;
  int remainingTime;
  Timer? timer;

  RentItem({required this.name, required this.price, required this.duration})
      : remainingTime = duration * 60;

  void startTimer(VoidCallback onUpdate) {
    remainingTime = duration * 60;
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        onUpdate();
      } else {
        timer.cancel();
      }
    });
  }
}

class RentListPage extends StatefulWidget {
  @override
  _RentListPageState createState() => _RentListPageState();
}

class _RentListPageState extends State<RentListPage> {
  List<RentItem> items = [];
  List<RentItem> rentedItems = [];
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

  void addItem(RentItem item) {
    setState(() {
      items.add(item);
    });
  }

  void rentItem(RentItem item) {
    RentItem newItem = RentItem(name: item.name, price: item.price, duration: item.duration);
    setState(() {
      rentedItems.add(newItem);
      newItem.startTimer(() {
        setState(() {});
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${item.name} has been rented for ${item.duration} minutes")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rent a Toy Car'),
        actions: [
          IconButton(
            icon: Icon(Icons.timer),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RentTimerPage(rentedItems: rentedItems)),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('\$${item.price.toStringAsFixed(2)} - ${item.duration} min'),
            onTap: () => rentItem(item),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newItem = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemPage()),
          );
          if (newItem != null) addItem(newItem);
        },
      ),
    );
  }
}