import 'package:flutter/material.dart';
import 'package:fyp_iqbal/models/rental.dart';
import 'package:intl/intl.dart';

class RentalBuilder extends StatefulWidget {
  const RentalBuilder({
    Key? key,
    required this.future,
    this.onRentalPage = false,
  }) : super(key: key);
  final Future<List<Rental>> future;
  final bool onRentalPage;

  @override
  _RentalBuilderState createState() => _RentalBuilderState();
}

class _RentalBuilderState extends State<RentalBuilder> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Rental>>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No rentals found'));
        }

        List<Rental> rentals = snapshot.data!;

        if (widget.onRentalPage) {
          final today = DateFormat.yMEd().format(DateTime.now());
          rentals = rentals.where((r) => r.date == today).toList();
        }


        // Scroll to bottom after frame renders
        _scrollToBottom();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: rentals.length,
            itemBuilder: (context, index) {
              final rental = rentals[index];
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
                    "${rental.itemType} ${rental.itemName}",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Start- ${rental.statime}",
                    style: TextStyle(
                      fontSize: 18.0,
                      //fontWeight: FontWeight.w500,
                    )
                  ),
                  SizedBox(width: 2.0),
                  Text(
                    "End- ${rental.endtime}",
                    style: TextStyle(
                      fontSize: 18.0,
                      //fontWeight: FontWeight.w500,
                    )
                  ),
                  SizedBox(width: 2.0),
                  Text(
                    //"Price- RM${rental.price.toString()}",
                    "Status- ${rental.status}",
                    style: TextStyle(
                      fontSize: 18.0,
                      //fontWeight: FontWeight.w500,
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
