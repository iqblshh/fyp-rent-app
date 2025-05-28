import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_iqbal/models/rentitem.dart';
import 'package:fyp_iqbal/services/database_service.dart';

class RentItemBuilder extends StatelessWidget {
  const RentItemBuilder({
    Key? key,
    required this.future,
    required this.onEdit,
    required this.onDelete,
    required this.onBook,
    this.showActions = true,
  }) : super(key: key);
  final Future<List<RentItem>> future;
  final Function(RentItem) onEdit;
  final Function(RentItem) onDelete;
  final Function(RentItem, int) onBook;
  final bool showActions;

  Future<String> getItemTypeName(int id) async {
    final DatabaseService _databaseService = DatabaseService();
    final itemtype = await _databaseService.itemtype(id);
    return itemtype.name;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RentItem>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final rentitem = snapshot.data![index];
              return _buildRentItemCard(rentitem, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildRentItemCard(RentItem rentitem, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            if (!showActions) ...[
              GestureDetector(
                onTap: () {
                  HapticFeedback.vibrate();
                  onBook(rentitem, 0);
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.close, color: Colors.orange[800]),
                ),
              ),
            ],
            SizedBox(width: 10.0),
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              alignment: Alignment.center,
              child: Text(
                rentitem.id.toString(),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rentitem.name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  FutureBuilder<String>(
                    future: getItemTypeName(rentitem.itemtypeId),
                    builder: (context, snapshot) {
                      return Text('ItemType: ${snapshot.data}');
                    },
                  ),
                  SizedBox(height: 4.0),
                ],
              ),
            ),
            SizedBox(width: 20.0),
            if (showActions) ...[
              GestureDetector(
                onTap: () {
                  HapticFeedback.vibrate();
                  onEdit(rentitem);
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.edit, color: Colors.orange[800]),
                ),
              ),
              SizedBox(width: 20.0),
              GestureDetector(
                onTap: () {
                  HapticFeedback.vibrate();
                  onDelete(rentitem);
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.delete, color: Colors.red[800]),
                ),
              ),
            ],
            if (!showActions) ...[
              GestureDetector(
                onTap: () {
                  HapticFeedback.vibrate();
                  onBook(rentitem, 1);
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.check, color: Colors.green),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
