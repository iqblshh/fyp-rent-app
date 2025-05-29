import 'package:flutter/material.dart';
import 'package:fyp_iqbal/services/database_service.dart';
import 'package:intl/intl.dart';

class RentalSummaryPage extends StatelessWidget {
  const RentalSummaryPage({super.key});

  Future<Map<String, dynamic>> _computeStats() async {
    final db = DatabaseService();
    final rentals = await db.rentals();

    final totalRentals = rentals.length;
    //final totalPaid = rentals.fold<int>(0, (sum, r) => sum + r.paid);
    final totalPrice = rentals.fold<int>(0, (sum, r) => sum + r.price);
    //final avgSale = totalRentals == 0 ? 0 : (totalPaid / totalRentals).round();
    final totalLate = rentals.where((r) => r.latetime.trim() != "0").length;
    final totalOngoing = rentals.where((r) => r.status == 0).length;
    final totalCompleted = rentals.where((r) => r.status == 1).length;
    //final totalUnpaid = totalPrice - totalPaid;

    // Calculate average sale per day
    final Set<String> uniqueDates = rentals.map((r) => r.date).toSet();
    final int totalDays = uniqueDates.length;
    final double avgSale = totalDays > 0 ? totalPrice / totalDays : 0.0;

    double totalHoursOpened = 0.0;
    for (final date in uniqueDates) {
      // Rentals for this date
      final dayRentals = rentals.where((r) => r.date == date).toList();
      if (dayRentals.isNotEmpty) {
        // Parse times as DateTime objects (using today's date for parsing)
        final times = dayRentals.map((r) {
          final start = DateFormat.Hm().parse(r.statime);
          final end = DateFormat.Hm().parse(r.endtime);
          return {'start': start, 'end': end};
        }).toList();

        // Find earliest start and latest end
        final earliestStart = times.map((t) => t['start']!).reduce((a, b) => a.isBefore(b) ? a : b);
        final latestEnd = times.map((t) => t['end']!).reduce((a, b) => a.isAfter(b) ? a : b);

        final duration = latestEnd.difference(earliestStart).inMinutes / 60.0;
        totalHoursOpened += duration;
      }
    }
    final double avgHourOpened = totalDays > 0 ? totalHoursOpened / totalDays : 0.0;

    return {
      'totalRentals': totalRentals,
      'totalPrice': totalPrice,
      'avgHourOpened': avgHourOpened,
      'avgSale': avgSale,
      'totalLate': totalLate,
      //'totalUnpaid': totalUnpaid,
      'totalOngoing': totalOngoing,
      'totalCompleted': totalCompleted,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _computeStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final data = snapshot.data as Map<String, dynamic>;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.2, // Make cards taller to avoid overflow
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildCard("Total Rentals", data['totalRentals'].toString()),
              _buildCard("Total Sales", "RM ${data['totalPrice']}"),
              //_buildCard("Avg Sale", "RM ${data['avgSale'].toStringAsFixed(2)}"),
              _buildCard("Late Rentals", data['totalLate'].toString()),
              _buildCard("Average Hour Operated", "Hour: ${data['avgHourOpened'].toStringAsFixed(1)}"),
              _buildCard("Ongoing Rentals", data['totalOngoing'].toString()),
              _buildCard("Average Sale Per Day", "RM ${data['avgSale']}"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
