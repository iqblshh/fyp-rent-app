import 'package:flutter/material.dart';
import 'package:fyp_iqbal/models/itemtype.dart';

class ItemTypeBuilder extends StatelessWidget {
  const ItemTypeBuilder({
    Key? key,
    required this.future,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);
  final Future<List<ItemType>> future;
  final Function(ItemType) onEdit;
  final Function(ItemType) onDelete;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemType>>(
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
              final itemtype = snapshot.data![index];
              return _buildItemTypeCard(itemtype, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildItemTypeCard(ItemType itemtype, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              alignment: Alignment.center,
              child: Text(
                itemtype.id.toString(),
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
                    itemtype.name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text('Timer: ${itemtype.timer} seconds'),
                  Text('Price: \$${itemtype.price}'),
                ],
              ),
            ),
            SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onEdit(itemtype),
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
              onTap: () => onDelete(itemtype),
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
        ),
      ),
    );
  }
}
