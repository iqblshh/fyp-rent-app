import 'package:flutter/material.dart';
import 'package:fyp_iqbal/common_widgets/itemtype_selector.dart';
import 'package:fyp_iqbal/models/itemtype.dart';
import 'package:fyp_iqbal/models/rentitem.dart';
import 'package:fyp_iqbal/services/database_service.dart';

class RentItemFormPage extends StatefulWidget {
  const RentItemFormPage({Key? key, this.rentitem}) : super(key: key);
  final RentItem? rentitem;

  @override
  _RentItemFormPageState createState() => _RentItemFormPageState();
}

class _RentItemFormPageState extends State<RentItemFormPage> {
  final TextEditingController _nameController = TextEditingController();
  static final List<ItemType> _itemtypes = [];

  final DatabaseService _databaseService = DatabaseService();

  int _selectedItemType = 0;

  @override
  void initState() {
    super.initState();
    if (widget.rentitem != null) {
      _nameController.text = widget.rentitem!.name;
    }
  }

  Future<List<ItemType>> _getItemTypes() async {
    final itemtypes = await _databaseService.itemtypes();
    if (_itemtypes.length == 0) _itemtypes.addAll(itemtypes);
    if (widget.rentitem != null) {
      _selectedItemType = _itemtypes.indexWhere((e) => e.id == widget.rentitem!.itemtypeId);
    }
    return _itemtypes;
  }

  Future<void> _onSave() async {
    final name = _nameController.text;
    final itemtype = _itemtypes[_selectedItemType];

    // Add save code here
    widget.rentitem == null
        ? await _databaseService.insertRentItem(
            RentItem(name: name, itemtypeId: itemtype.id!),
          )
        : await _databaseService.updateRentItem(
            RentItem(
              id: widget.rentitem!.id,
              name: name,
              itemtypeId: itemtype.id!,
            ),
          );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New RentItem Record'),
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
                hintText: 'Enter name of the rentitem here',
              ),
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
                  'Save the RentItem data',
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
