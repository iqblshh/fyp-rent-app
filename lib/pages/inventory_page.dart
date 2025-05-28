import 'package:flutter/material.dart';
import 'package:fyp_iqbal/common_widgets/rentitem_builder.dart';
import 'package:fyp_iqbal/common_widgets/itemtype_builder.dart';
import 'package:fyp_iqbal/common_widgets/rental_builder.dart';
import 'package:fyp_iqbal/models/itemtype.dart';
import 'package:fyp_iqbal/models/rentitem.dart';
import 'package:fyp_iqbal/models/rental.dart';
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

  Future<List<Rental>> _getRentals() async {
    return await _databaseService.rentals();
  }

  Future<void> _onRentItemDelete(RentItem rentitem) async {
    await _databaseService.deleteRentItem(rentitem.id!);
  }

  Future<void> _onItemTypeDelete(ItemType itemtype) async {
    await _databaseService.deleteItemType(itemtype.id!);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Inventory Management'),
          backgroundColor: const Color.fromARGB(255, 137, 164, 209),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Rental'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Scaffold(
              body: RentItemBuilder(
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
                onBook: (_, __) {},
              ),
              floatingActionButton: FloatingActionButton(
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
                child: FaIcon(FontAwesomeIcons.plus),
              ),
            ),
            Scaffold(
              body: ItemTypeBuilder(
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
              floatingActionButton: FloatingActionButton(
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
            ),
            Scaffold(
              body: RentalBuilder(
                future: _getRentals(),
                onDelete: (_) {},
                onStatus: (_, __) {},
                onPaid: (_, __) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
