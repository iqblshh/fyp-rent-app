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

class CheckPage extends StatefulWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Rental'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Item'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Timer'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RentItemBuilder(
              future: _getRentItems(),
              onEdit: (_) {}, // You can still provide a dummy function
              onDelete: (_) {},
              showActions: false,
            ),
            RentalBuilder(
              future: _getRentals(),
            ),
          ],
        ),
      ),
    );
  }
}
