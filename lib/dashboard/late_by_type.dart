import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fyp_iqbal/services/database_service.dart';

class LateReturnByItemTypeChart extends StatefulWidget {
  const LateReturnByItemTypeChart({super.key});

  @override
  State<LateReturnByItemTypeChart> createState() => _LateReturnByItemTypeChartState();
}

class _LateReturnByItemTypeChartState extends State<LateReturnByItemTypeChart> {
  Map<String, int> lateCounts = {};

  @override
  void initState() {
    super.initState();
    _loadLateData();
  }

  Future<void> _loadLateData() async {
    final rentals = await DatabaseService().rentals();
    final Map<String, int> counts = {};

    for (var r in rentals) {
      if (r.latetime.trim() != "0") {
        counts[r.itemType] = (counts[r.itemType] ?? 0) + 1;
      }
    }

    setState(() {
      lateCounts = counts;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (lateCounts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final labels = lateCounts.keys.toList();
    final List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < labels.length; i++) {
      final count = lateCounts[labels[i]]!;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              width: 18,
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, interval: 1, reservedSize: 20),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= labels.length) return const SizedBox();
                        return SideTitleWidget(
                          meta: meta,
                          //axisSide: meta.axisSide,
                          child: Text(
                            labels[index],
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}