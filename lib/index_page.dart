import 'package:flutter/material.dart';
import 'package:fyp_iqbal/pages/inventory_page.dart';
import 'package:fyp_iqbal/pages/check_page.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckPage()),
                );
              },
              child: Text('Rent'),
            ),
            SizedBox(height: 20), // Space between buttons
            ElevatedButton(
              onPressed: () {
                // Action for Item + button
                //print('Item + button pressed');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Item +'),
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