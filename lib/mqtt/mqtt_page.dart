import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:fyp_iqbal/pages/check_page.dart';
import 'package:fyp_iqbal/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fyp_iqbal/mqtt/mqtt_app_state.dart';
import 'package:fyp_iqbal/mqtt/mqtt_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MQTTView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MQTTViewState();
  }
}

class _MQTTViewState extends State<MQTTView> {
  final TextEditingController _hostTextController = TextEditingController();
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  late MQTTAppState currentAppState;
  late MQTTManager manager;

  @override
  void initState() {
    super.initState();
    _loadSavedInputs();
  }

  Future<void> _loadSavedInputs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hostTextController.text = prefs.getString('mqtt_host') ?? '';
      _topicTextController.text = prefs.getString('mqtt_topic') ?? '';
      _messageTextController.text = prefs.getString('mqtt_message') ?? '';
    });
  }

  Future<void> _saveInputs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mqtt_host', _hostTextController.text);
    await prefs.setString('mqtt_topic', _topicTextController.text);
    await prefs.setString('mqtt_message', _messageTextController.text);
  }

  @override
  void dispose() {
    _saveInputs(); // Save on dispose
    _hostTextController.dispose();
    _messageTextController.dispose();
    _topicTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    currentAppState = appState;
    final Scaffold scaffold = Scaffold(
      appBar: AppBar(title: const Text('MQTT'), centerTitle: true, backgroundColor: const Color.fromARGB(255, 137, 164, 209)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _buildColumn()
        ),
      )
    );
    return scaffold;
  }

  Widget _buildColumn() {
    return Column(
      children: <Widget>[
        _buildConnectionStateText(
            _prepareStateMessageFrom(currentAppState.getAppConnectionState)),
        _buildEditableColumn(),
        _buildScrollableTextWith(currentAppState.getHistoryText)
      ],
    );
  }

  Widget _buildEditableColumn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildTextFieldWith(_hostTextController, 'Enter broker address',
              currentAppState.getAppConnectionState),
          const SizedBox(height: 10),
          _buildTextFieldWith(
              _topicTextController,
              'Enter a topic to subscribe or listen',
              currentAppState.getAppConnectionState),
          const SizedBox(height: 10),
          _buildPublishMessageRow(),
          const SizedBox(height: 10),
          _buildConnecteButtonFrom(currentAppState.getAppConnectionState)
        ],
      ),
    );
  }

  Widget _buildPublishMessageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: _buildTextFieldWith(_messageTextController, 'Enter a message',
              currentAppState.getAppConnectionState),
        ),
        _buildSendButtonFrom(currentAppState.getAppConnectionState)
      ],
    );
  }

  Widget _buildConnectionStateText(String status) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              color: status == "Connected"
              ? Colors.green
              : Colors.deepOrangeAccent,
              child: Text(status, textAlign: TextAlign.center)),
        ),
      ],
    );
  }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = false;
    if (controller == _messageTextController &&
        state == MQTTAppConnectionState.connected) {
      shouldEnable = true;
    } else if ((controller == _hostTextController &&
            state == MQTTAppConnectionState.disconnected) ||
        (controller == _topicTextController &&
            state == MQTTAppConnectionState.disconnected)) {
      shouldEnable = true;
    }
    return TextField(
        enabled: shouldEnable,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          labelText: hintText,
        ),
        onChanged: (_) => _saveInputs(), // Save on every change
    );
  }

  Widget _buildScrollableTextWith(String text) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 400,
        height: 200,
        child: SingleChildScrollView(
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildConnecteButtonFrom(MQTTAppConnectionState state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            onPressed: state == MQTTAppConnectionState.disconnected
                ? _configureAndConnect
                : null,
            child: const Text('Connect'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: state == MQTTAppConnectionState.connected
                ? _disconnect
                : null,
            child: const Text('Disconnect'),
          ),
        ),
      ],
    );
  }

  Widget _buildSendButtonFrom(MQTTAppConnectionState state) {
    return ElevatedButton(
      onPressed: state == MQTTAppConnectionState.connected
          ? () {
              _publishMessage(_messageTextController.text);
            }
          : null,
      child: const Text('Send'),
    );
  }

  String _prepareStateMessageFrom(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Connected';
      case MQTTAppConnectionState.connecting:
        return 'Connecting';
      case MQTTAppConnectionState.disconnected:
        return 'Disconnected';
    }
  }

  void _configureAndConnect() {
    String osPrefix = 'Flutter_Android';
    
    manager = MQTTManager(
      host: _hostTextController.text,
      topic: _topicTextController.text,
      identifier: osPrefix,
      state: currentAppState,
      onMessageReceived: (msg) {
        _onMqttMessage(msg);
      },
    );
    manager.initializeMQTTClient();
    manager.connect();
    _saveInputs(); // Save when connecting
  }

  void _onMqttMessage(String message) async {
    try {
      final now = DateFormat.Hm().format(DateTime.now());

      final cleanedMessage = message.replaceAll('"', '').trim();
      final data = int.tryParse(cleanedMessage);
      if (data != null) {
        final db = await DatabaseService().database;

        final List<Map<String, dynamic>> result = await db.query(
          'rentals',
          where: 'rentitemId = ?',
          whereArgs: [data],
          orderBy: 'id DESC',
          limit: 1,
        );

        if (result.isNotEmpty) {
          print('This IS A RESULT: $result');
          final rental = result.first;
          final int rentalId = rental['id'];
          final int currentStatus = rental['status'] ?? 0;

          if (currentStatus != 1) {
            await DatabaseService().updateRentalStatus(rentalId, 1);
            await DatabaseService().updateRentalTime(rentalId, now);
            print('Updated rental ID $rentalId status to 1');

            // Refresh UI if available
            if (CheckPage.refreshCallback != null) {
              CheckPage.refreshCallback!();
            }
          } else {
            print('Rental ID $rentalId already has status 1');
          }
        } else {
          print('No rental found for rentitemId $data');
        }
      }
    } catch (e) {
      print("MQTT message pprocessing error: $e");
    }
  }

  void _disconnect() {
    manager.disconnect();
  }

  void _publishMessage(String text) {
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    final String message = osPrefix + ' says: ' + text;
    manager.publish(message);
    _messageTextController.clear();
    _saveInputs(); // Save after sending
  }
}