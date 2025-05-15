import 'package:flutter/material.dart';
import 'package:fyp_iqbal/jsonModels/rent_item.dart';
import 'package:fyp_iqbal/db/database_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RentItemBuilder extends StatelessWidget {
  const RentItemBuilder({
    super.key,
    required this.future,
    required this.onEdit,
    required this.onDelete,
  });
  final Future<List<RentItem>> future;
  final Function(RentItem) onEdit;
  final Function(RentItem) onDelete;

  Future<String> getBrandName(int id) async {
    final DatabaseHelper _databaseService = DatabaseHelper();
    final itemtype = await _databaseService.itemtype(type);
    return itemtype.type;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RentItem>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final shoe = snapshot.data![index];
              return _buildRentItemCard(shoe, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildRentItemCard(RentItem shoe, BuildContext context) {
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
                color: Colors.grey[200],
              ),
              alignment: Alignment.center,
              child: const FaIcon(FontAwesomeIcons.gifts, size: 18.0),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shoe.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  FutureBuilder<String>(
                    future: getBrandName(shoe.brandId),
                    builder: (context, snapshot) {
                      return Text('Brand: ${snapshot.data}');
                    },
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text('Size: ${shoe.size1.toString()}, Color: '),
                      Container(
                        height: 15.0,
                        width: 15.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: shoe.color,
                          border: Border.all(
                            color: Colors.black,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onEdit(shoe),
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
            const SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onDelete(shoe),
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
