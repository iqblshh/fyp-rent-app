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

  String _formatRemainingTime(Duration duration) {
    if (duration.isNegative) return "Expired";

    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  DateTime _parseEndTime(String endtimeString) {
    final now = DateTime.now();
    final parts = endtimeString.split(':');
    return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
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
    final endTime = _parseEndTime(rental.endtime);
    final now = DateTime.now();
    final remaining = endTime.difference(now);
    final formattedTime = _formatRemainingTime(remaining);

    return Card(
      color: remaining.isNegative ? Colors.red[200] : Colors.green[200],
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
                  SizedBox(width: 2.0),
                  Text(
                    "Timer- $formattedTime",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
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
