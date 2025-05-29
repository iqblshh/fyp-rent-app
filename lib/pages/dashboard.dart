import 'package:flutter/material.dart';
import 'package:fyp_iqbal/dashboard/late_by_type.dart';
import 'package:fyp_iqbal/dashboard/rental_summary_page.dart';
import 'package:fyp_iqbal/dashboard/type_sale_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const RentalSummaryPage(),
    const LateReturnByItemTypeChart(),
    //const RentalByDayChart(),
    //const SaleByDateChart(),
    //const SaleByDayChart(),
    //const LateReturnChart(),
    const ItemTypeCountChart(),
    //const RentalDataTablePage(),
  ];

  final List<String> _titles = [
    "Rental Summary",
    "Late Return by Item Type",
    //"Rental by Day",
    //"Sale by Date",
    //"Sale by Day",
    //"Late Return Count",
    "Item Type Count",
    //"Rental Data Table"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: const Color.fromARGB(255, 137, 164, 209),
      ),
      endDrawer: Drawer(
        child: ListView.builder(
          itemCount: _titles.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.analytics),
              title: Text(_titles[index]),
              selected: index == _selectedIndex,
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                  Navigator.pop(context);
                });
              },
            );
          },
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
