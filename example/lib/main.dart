import 'package:flutter/material.dart';
import 'dart:async';

import 'package:persian_flutter_plugin_example/persian_flutter_plugin_example.dart';

const asDouble = false;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription<bool> _isChargingSubscription;
  bool _lowPowerMode = false, _isCharging = false;
  num _batteryLevel = -1;
  String? _suggestion;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  @override
  void dispose() {
    _isChargingSubscription.cancel();
    super.dispose();
  }

  Future<void> _initState() async {
    final lowPowerMode = await PersianFlutterPluginExample.isLowPowerMode();
    final batteryLevel =
        await PersianFlutterPluginExample.getBatteryLevel(asDouble);
    final isCharging = await PersianFlutterPluginExample.isCharging();
    _suggestion = PersianFlutterPluginExample.getSuggestion(
        asDouble ? batteryLevel.toDouble() : batteryLevel / 100, lowPowerMode);
    _isChargingSubscription = PersianFlutterPluginExample.isChargingStream
        .listen(_isChargingEventReceived);

    if (!mounted) return;

    setState(() {
      _lowPowerMode = lowPowerMode;
      _isCharging = isCharging;
      _batteryLevel = batteryLevel;
    });
  }

  _isChargingEventReceived(bool event) => setState(() => _isCharging = event);

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Persian Flutter plugin example')),
          body: Center(
            child: Column(
              children: [
                Text('Low power mode is ${_lowPowerMode ? 'on' : 'off'}'),
                Text('Battery level is $_batteryLevel'
                    ' and is ${_isCharging ? 'Charging' : 'Discharging'}'),
                if(_suggestion!=null)
                  Text('Suggestion: $_suggestion')
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
      );
}
