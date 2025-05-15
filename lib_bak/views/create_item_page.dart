import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'rent_list_page.dart';

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