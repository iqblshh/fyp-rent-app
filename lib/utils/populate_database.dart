import 'package:fyp_iqbal/models/itemtype.dart';
import 'package:fyp_iqbal/models/rentitem.dart';
import 'package:fyp_iqbal/services/database_service.dart';

Future<void> populateDatabase() async {
  final databaseService = DatabaseService();

  // Insert sample data for ItemType
  await databaseService.insertItemType(ItemType(
    id: 1,
    name: 'Camera',
    timer: 24,
    price: 100,
  ));
  await databaseService.insertItemType(ItemType(
    id: 2,
    name: 'Laptop',
    timer: 48,
    price: 200,
  ));

  // Insert sample data for RentItem
  await databaseService.insertRentItem(RentItem(
    id: 1,
    name: 'Canon DSLR',
    itemtypeId: 1,
  ));
  await databaseService.insertRentItem(RentItem(
    id: 2,
    name: 'MacBook Pro',
    itemtypeId: 2,
  ));

  print('Database populated successfully!');
}
