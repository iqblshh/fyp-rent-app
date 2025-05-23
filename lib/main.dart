/**
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

*/

import 'package:flutter/material.dart';
import 'package:fyp_iqbal/mqtt_stf/mqtt/state/MQTTAppState.dart';
import 'package:fyp_iqbal/mqtt_stf/widgets/mqttView.dart';
import 'package:provider/provider.dart';

void main() => runApp(RentApp());

class RentApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*
    final MQTTManager manager = MQTTManager(host:'test.mosquitto.org',topic:'flutter/amp/cool',identifier:'ios');
    manager.initializeMQTTClient();

     */

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ChangeNotifierProvider<MQTTAppState>(
          create: (_) => MQTTAppState(),
          child: MQTTView(),
        ));
  }
}