import 'package:flutter/material.dart';
import 'package:fyp_iqbal/models/itemtype.dart';
import 'package:fyp_iqbal/services/database_service.dart';

class ItemTypeFormPage extends StatefulWidget {
  const ItemTypeFormPage({Key? key, this.itemtype}) : super(key: key);
  final ItemType? itemtype;

  @override
  _ItemTypeFormPageState createState() => _ItemTypeFormPageState();
}

class _ItemTypeFormPageState extends State<ItemTypeFormPage> {
  final TextEditingController _nameController = TextEditingController();
  int? _selectedTimer;
  bool _isCustomTimer = false;
  final TextEditingController _customTimerController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    if (widget.itemtype != null) {
      _nameController.text = widget.itemtype!.name;
      
      final existingTimer = widget.itemtype!.timer;
      if (existingTimer == 10 || existingTimer == 15) {
        _selectedTimer = existingTimer;
      } else {
        _selectedTimer = null;
        _isCustomTimer = true;
        _customTimerController.text = existingTimer.toString();
      }

      _priceController.text = widget.itemtype!.price.toString();
    }
  }

  Future<void> _onSave() async {
    final name = _nameController.text;
    int timer = _isCustomTimer
      ? int.tryParse(_customTimerController.text) ?? 0
      : _selectedTimer ?? 0;
    final price = int.tryParse(_priceController.text) ?? 0;

    widget.itemtype == null
        ? await _databaseService.insertItemType(
            ItemType(
              name: name, 
              timer: timer,
              price: price
            )
          )
        : await _databaseService.updateItemType(
            ItemType(
              id: widget.itemtype!.id,
              name: name,
              timer: timer,
              price: price
            ),
          );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new itemtype'),
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
                hintText: 'Enter name of the itemtype here',
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<int?>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select Timer',
              ),
              value: _isCustomTimer ? null : _selectedTimer,
              items: const [
                DropdownMenuItem(value: 10, child: Text('10 seconds')),
                DropdownMenuItem(value: 15, child: Text('15 seconds')),
                DropdownMenuItem(value: null, child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedTimer = value;
                  _isCustomTimer = value == null;
                  if (! _isCustomTimer) _customTimerController.clear();
                });
              },
            ),
            if (_isCustomTimer)
              SizedBox(height: 16.0),
            if (_isCustomTimer)
              TextField(
                controller: _customTimerController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter custom timer in seconds',
                ),
              ),
            SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter price',
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: _onSave,
                child: Text(
                  'Save the ItemType',
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
