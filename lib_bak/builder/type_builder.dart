import 'package:flutter/material.dart';
import 'package:fyp_iqbal/jsonModels/item_type.dart';

class TypeBuilder extends StatelessWidget {
  const TypeBuilder({
    super.key,
    required this.future,
    required this.onEdit,
    required this.onDelete,
  });
  final Future<List<ItemType>> future;
  final Function(ItemType) onEdit;
  final Function(ItemType) onDelete;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemType>>(
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
              final brand = snapshot.data![index];
              return _buildTypeCard(brand, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildTypeCard(ItemType brand, BuildContext context) {
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
                brand.type,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand.timer.toString(),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(brand.price.toString()),
                ],
              ),
            ),
            const SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onEdit(brand),
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
              onTap: () => onDelete(brand),
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
