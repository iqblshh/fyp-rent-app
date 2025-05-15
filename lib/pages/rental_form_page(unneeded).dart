/**
import 'package:flutter/material.dart';
import 'package:fyp_iqbal/models/itemtype.dart';
import 'package:fyp_iqbal/models/rentitem.dart';
import 'package:fyp_iqbal/models/rental.dart';
import 'package:fyp_iqbal/services/database_service.dart';

class RentalFormPage extends StatefulWidget {
  const RentalFormPage({Key? key, this.rental}) : super(key: key);
  final Rental? rental;

  @override
  _RentalFormPageState createState() => _RentalFormPageState();
}

class _RentalFormPageState extends State<RentalFormPage> {
  final TextEditingController _nameController = TextEditingController();

  static final List<ItemType> _itemtypes = [];

  final DatabaseService _databaseService = DatabaseService();

  int _selectedAge = 0;
  int _selectedColor = 0;
  int _selectedItemType = 0;

  @override
  void initState() {
    super.initState();
    if (widget.rental != null) {
      _nameController.text = widget.rental!.name;
      _selectedAge = widget.rental!.age;
      _selectedColor = _colors.indexOf(widget.rental!.color);
    }
  }

  Future<List<ItemType>> _getItemTypes() async {
    final itemtypes = await _databaseService.itemtypes();
    if (_itemtypes.length == 0) _itemtypes.addAll(itemtypes);
    if (widget.rental != null) {
      _selectedItemType = _itemtypes.indexWhere((e) => e.id == widget.rental!.itemtypeId);
    }
    return _itemtypes;
  }

  Future<void> _onSave() async {
    final name = _nameController.text;
    final age = _selectedAge;
    final color = _colors[_selectedColor];
    final itemtype = _itemtypes[_selectedItemType];

    // Add save code here
    widget.rental == null
        ? await _databaseService.insertRental(
            Rental(name: name, age: age, color: color, itemtypeId: itemtype.id!),
          )
        : await _databaseService.updateRental(
            Rental(
              id: widget.rental!.id,
              name: name,
              age: age,
              color: color,
              itemtypeId: itemtype.id!,
            ),
          );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Rental Record'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter name of the rental here',
              ),
            ),
            SizedBox(height: 16.0),
            // Age Slider
            AgeSlider(
              max: 30.0,
              selectedAge: _selectedAge.toDouble(),
              onChanged: (value) {
                setState(() {
                  _selectedAge = value.toInt();
                });
              },
            ),
            SizedBox(height: 16.0),
            // Color Picker
            ColorPicker(
              colors: _colors,
              selectedIndex: _selectedColor,
              onChanged: (value) {
                setState(() {
                  _selectedColor = value;
                });
              },
            ),
            SizedBox(height: 24.0),
            // ItemType Selector
            FutureBuilder<List<ItemType>>(
              future: _getItemTypes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading itemtypes...");
                }
                return ItemTypeSelector(
                  itemtypes: _itemtypes.map((e) => e.name).toList(),
                  selectedIndex: _selectedItemType,
                  onChanged: (value) {
                    setState(() {
                      _selectedItemType = value;
                    });
                  },
                );
              },
            ),
            SizedBox(height: 24.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: _onSave,
                child: Text(
                  'Save the Rental data',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

**/
