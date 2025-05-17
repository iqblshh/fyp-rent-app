import 'package:flutter/material.dart';
import 'package:fyp_iqbal/models/rental.dart';

class RentalBuilder extends StatelessWidget {
  const RentalBuilder({
    Key? key,
    required this.future,
  }) : super(key: key);
  final Future<List<Rental>> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Rental>>(
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
              final rental = snapshot.data![index];
              return _buildRentalCard(rental, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildRentalCard(Rental rental, BuildContext context) {
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
                rental.id.toString(),
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
                    rental.itemType,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(rental.endtime),
                  SizedBox(width: 2.0),
                  Text(rental.date),
                  SizedBox(width: 2.0),
                  Text(rental.price.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
