import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

void main() {
  runApp(RentApp());
}

class RentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Toy Car Rent',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RentListPage(),
    );
  }
}

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

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController customDurationController = TextEditingController();
  int? duration = 10;
  bool isCustom = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Rent Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Item Name')),
            TextField(controller: priceController, decoration: InputDecoration(labelText: 'Item Price'), keyboardType: TextInputType.number),
            DropdownButton<int?>(
              value: isCustom ? null : duration,
              onChanged: (newValue) {
                setState(() {
                  if (newValue == null) {
                    isCustom = true;
                    duration = null;
                  } else {
                    isCustom = false;
                    duration = newValue;
                  }
                });
              },
              items: [10, 15].map((e) => DropdownMenuItem(value: e, child: Text('$e minutes'))).toList() +
                  [DropdownMenuItem(value: null, child: Text('Other'))],
            ),
            if (isCustom)
              TextField(
                controller: customDurationController,
                decoration: InputDecoration(labelText: 'Enter minutes'),
                keyboardType: TextInputType.number,
              ),
            ElevatedButton(
              child: Text('Add Item'),
              onPressed: () {
                final name = nameController.text;
                final price = double.tryParse(priceController.text) ?? 0;
                final selectedDuration = isCustom
                    ? int.tryParse(customDurationController.text) ?? 10
                    : duration ?? 10;
                Navigator.pop(context, RentItem(name: name, price: price, duration: selectedDuration));
              },
            ),
          ],
        ),
      ),
    );
  }
}
