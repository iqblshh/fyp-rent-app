import 'package:flutter/material.dart';
import 'rent_list_page.dart';
import 'create_item_page.dart';
import 'timer_page.dart';

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Action for Rent button
                print('Rent button pressed');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RentListPage()),
                );
              },
              child: Text('Rent'),
            ),
            SizedBox(height: 20), // Space between buttons
            ElevatedButton(
              onPressed: () {
                // Action for Item + button
                print('Item + button pressed');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddItemPage()),
                );
              },
              child: Text('Item +'),
            ),
            SizedBox(height: 20), // Space between buttons
            ElevatedButton(
              onPressed: () {
                // Action for Sales button
                print('Sales button pressed');
              },
              child: Text('Sales'),
            ),
            SizedBox(height: 20), // Space between buttons
            ElevatedButton(
              onPressed: () {
                // Action for Setting button
                print('Setting button pressed');
              },
              child: Text('Setting'),
            ),
          ],
        ),
      ),
    );
  }
}