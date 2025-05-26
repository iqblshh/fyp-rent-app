import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_iqbal/models/rental.dart';
import 'package:fyp_iqbal/services/database_service.dart';
import 'package:intl/intl.dart';

class RentalBuilder extends StatefulWidget {
  const RentalBuilder({
    Key? key,
    required this.future,
    required this.onDelete,
    required this.onStatus,
    this.onRentalPage = false,
  }) : super(key: key);
  final Future<List<Rental>> future;
  final Function(Rental) onDelete;
  final Function(Rental, int) onStatus;
  final bool onRentalPage;

  @override
  _RentalBuilderState createState() => _RentalBuilderState();
}

class _RentalBuilderState extends State<RentalBuilder> {
  final ScrollController _scrollController = ScrollController();
  final DatabaseService _databaseService = DatabaseService();


  List<Rental> _allRentals = [];
  List<Rental> _displayedRentals = [];
  final int _itemsPerPage = 10;
  int _currentPage = 0;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    //_loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      _loadMoreData();
    }
  }

  Future<void> _loadInitialData() async {
    final allData = await widget.future;
    if (!mounted) return;

    setState(() {
      _allRentals = widget.onRentalPage
          ? allData.where((r) => r.date == DateFormat.yMEd().format(DateTime.now())).toList()
          : allData;
      _displayedRentals = _allRentals.take(_itemsPerPage).toList();
      _currentPage = 1;
    });
  }

  void _loadMoreData() {
    if (_isLoadingMore || _displayedRentals.length >= _allRentals.length) return;

    setState(() => _isLoadingMore = true);

    Future.delayed(Duration(milliseconds: 500), () {
      final nextItems = _allRentals.skip(_currentPage * _itemsPerPage).take(_itemsPerPage).toList();
      setState(() {
        _displayedRentals.addAll(nextItems);
        _currentPage++;
        _isLoadingMore = false;
      });
    });
  }

  //Rental(
        //rentitemId: rental.id!, 
        //itemType: rental.itemType, 
        //itemName: rental.itemName, 
        //statime: rental.statime, 
        //endtime: rental.endtime, 
        //date: rental.date, 
        //price: rental.price, 
        //paid: rental.paid, 
        //status: 0,
      //),

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  /**
  @override
  Widget build(BuildContext context) {
    if (_allRentals.isEmpty && _displayedRentals.isEmpty) {
      return Center(child: Text('No rentals found'));
    }

    if (_displayedRentals.isEmpty) {
      return Center(child: Text('No rentals found'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _displayedRentals.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _displayedRentals.length) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ));
          }

          final rental = _displayedRentals[index];
          return _buildRentalCard(rental, context);
        },
      ),
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Rental>>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No rentals found'));
        }

        final allData = widget.onRentalPage
            ? snapshot.data!.where((r) => r.date == DateFormat.yMEd().format(DateTime.now())).toList()
            : snapshot.data!;

        _allRentals = allData;
        _displayedRentals = _allRentals.take(_itemsPerPage).toList();
        _currentPage = 1;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _displayedRentals.length + (_isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _displayedRentals.length) {
                return Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ));
              }

              final rental = _displayedRentals[index];
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
      color: widget.onRentalPage
        ? (remaining.isNegative ? Colors.red[200] : Colors.green[200])
        : null,
      //color: remaining.isNegative ? Colors.red[200] : Colors.green[200],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Column(
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
                SizedBox(height: 30.0),                  
                if (widget.onRentalPage) ...[
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.vibrate();
                      widget.onDelete(rental);
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
              ],
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
                  widget.onRentalPage 
                    ? Text(
                      "Timer- $formattedTime",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      )
                    )
                    : Text(
                      rental.date,
                      //"Status- ${rental.status}",
                      style: TextStyle(
                        fontSize: 18.0,
                        //fontWeight: FontWeight.w500,
                      )
                    ),
                ],
              ),
            ),
            if (widget.onRentalPage) ...[
              GestureDetector(
                onTap: () {
                  HapticFeedback.vibrate();
                  final newStatus = rental.status == 0 ? 1 : 0;
                  widget.onStatus(rental, newStatus);
                },
                child: Container(
                  height: 40.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.grey[200],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    rental.status == 1 ? 'Finished' : 'On Track',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: rental.status == 1 ? Colors.green : Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
