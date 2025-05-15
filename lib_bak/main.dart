import 'package:flutter/material.dart';
import 'views/index_page.dart';

void main() {
  runApp(RentApp());
}

class RentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Toy Car Rent',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IndexPage(),
    );
  }
}
