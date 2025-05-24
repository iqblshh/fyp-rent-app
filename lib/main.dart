
import 'package:flutter/material.dart';
import 'package:fyp_iqbal/index_page.dart';
import 'package:fyp_iqbal/mqtt/mqtt_app_state.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MQTTAppState()),
      ],
      child: RentApp(),
    ),
  );
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


/** 
import 'package:flutter/material.dart';
import 'package:fyp_iqbal/mqtt/mqtt_app_state.dart';
import 'package:fyp_iqbal/mqtt/mqtt_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MQTTAppState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT Demo',
      home: MqttView(),
    );
  }
}
*/