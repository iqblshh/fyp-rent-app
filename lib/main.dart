import 'package:flutter/material.dart';
import 'package:fyp_iqbal/index_page.dart';

void main() {
  runApp(RentApp());
}

class RentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQFLite Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: IndexPage(),
    );
  }
}
