import 'package:flutter/material.dart';
import 'package:fyp_iqbal/common_widgets/rentitem_builder.dart';
import 'package:fyp_iqbal/common_widgets/itemtype_builder.dart';
import 'package:fyp_iqbal/models/itemtype.dart';
import 'package:fyp_iqbal/models/rentitem.dart';
import 'package:fyp_iqbal/pages/itemtype_form_page.dart';
import 'package:fyp_iqbal/pages/rentitem_form_page.dart';
import 'package:fyp_iqbal/services/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<RentItem>> _getRentItems() async {
    return await _databaseService.rentitems();
  }

  Future<List<ItemType>> _getItemTypes() async {
    return await _databaseService.itemtypes();
  }

  Future<void> _onRentItemDelete(RentItem rentitem) async {
    await _databaseService.deleteRentItem(rentitem.id!);
    setState(() {});
  }

  Future<void> _onItemTypeDelete(ItemType itemtype) async {
    await _databaseService.deleteItemType(itemtype.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('RentItem Database'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('RentItems'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('ItemTypes'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RentItemBuilder(
              future: _getRentItems(),
              onEdit: (value) {
                {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => RentItemFormPage(rentitem: value),
                          fullscreenDialog: true,
                        ),
                      )
                      .then((_) => setState(() {}));
                }
              },
              onDelete: _onRentItemDelete,
            ),
            ItemTypeBuilder(
              future: _getItemTypes(),
              onEdit: (value) {
                {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => ItemTypeFormPage(itemtype: value),
                          fullscreenDialog: true,
                        ),
                      )
                      .then((_) => setState(() {}));
                }
              },
              onDelete: _onItemTypeDelete,
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) => ItemTypeFormPage(),
                        fullscreenDialog: true,
                      ),
                    )
                    .then((_) => setState(() {}));
              },
              heroTag: 'addItemType',
              child: FaIcon(FontAwesomeIcons.plus),
            ),
            SizedBox(height: 12.0),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) => RentItemFormPage(),
                        fullscreenDialog: true,
                      ),
                    )
                    .then((_) => setState(() {}));
              },
              heroTag: 'addRentItem',
              child: FaIcon(FontAwesomeIcons.paw),
            ),
          ],
        ),
      ),
    );
  }
}
