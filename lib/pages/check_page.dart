import 'package:flutter/material.dart';
import 'package:fyp_iqbal/common_widgets/rentitem_builder.dart';
import 'package:fyp_iqbal/common_widgets/rental_builder.dart';
import 'package:fyp_iqbal/models/rentitem.dart';
import 'package:fyp_iqbal/models/rental.dart';
import 'package:fyp_iqbal/services/database_service.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class CheckPage extends StatefulWidget {
  const CheckPage({Key? key, this.rental}) : super(key: key);
  final Rental? rental;

  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  final DatabaseService _databaseService = DatabaseService();
  Timer? _refreshTimer;
  
  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<List<RentItem>> _getRentItems() async {
    return await _databaseService.rentitems();
  }

  Future<List<Rental>> _getRentals() async {
    final allRentals = await _databaseService.rentals();
    final today = DateTime.now();

    return allRentals.where((rental) {
      final rentalDate = DateFormat.yMEd().parse(rental.date);
      return rentalDate.year == today.year &&
            rentalDate.month == today.month &&
            rentalDate.day == today.day;
    }).toList();
  }

  Future<void> _onBookItem(RentItem rentitem, int status) async {
    final itemtypes = await _databaseService.itemtypes();
    final now = DateTime.now();

    final itemtype = itemtypes.firstWhere(
      (type) => type.id == rentitem.itemtypeId,
      orElse: () => throw Exception('ItemType not found'),
    );

    await _databaseService.insertRental(
      Rental(
        rentitemId: rentitem.id!, 
        itemType: itemtype.name, 
        itemName: rentitem.name, 
        statime: DateFormat.Hm().format(now), 
        endtime: DateFormat.Hm().format(now.add(Duration(minutes: itemtype.timer))), 
        date: DateFormat.yMEd().format(now), 
        price: itemtype.price, 
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
