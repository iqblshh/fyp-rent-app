import 'package:flutter/material.dart';
import 'package:fyp_iqbal/common_widgets/rentitem_builder.dart';
import 'package:fyp_iqbal/common_widgets/rental_builder.dart';
import 'package:fyp_iqbal/models/rentitem.dart';
import 'package:fyp_iqbal/models/rental.dart';
import 'package:fyp_iqbal/services/database_service.dart';
import 'package:intl/intl.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({Key? key, this.rental}) : super(key: key);
  final Rental? rental;

  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<RentItem>> _getRentItems() async {
    return await _databaseService.rentitems();
  }

  Future<List<Rental>> _getRentals() async {
    return await _databaseService.rentals();
  }

///
  /**
   * 
  id
  itemId
  itemType
  itemName
  statime
  endtime
  date
  price
  status
   * 
   */
///

  Future<void> _onBookItem(RentItem rentitem, int status) async {
    final itemtypes = await _databaseService.itemtypes();
    final now = DateTime.now();

    await _databaseService.insertRental(
      Rental(
        itemId: rentitem.id!, 
        itemType: itemtypes[rentitem.itemtypeId].name, 
        itemName: rentitem.name, 
        statime: DateFormat.Hm().format(now), 
        endtime: DateFormat.Hm().format(now.add(Duration(minutes: itemtypes[rentitem.itemtypeId].timer))), 
        date: DateFormat.yMEd().format(now), 
        price: itemtypes[rentitem.itemtypeId].price, 
        status: status,
      ),
    );
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
              onBook: _onBookItem,
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
