import 'package:flutter/services.dart';

class PluginChannel {
  static const MethodChannel _methodChannel =
  MethodChannel('com.persian_flutter/plugin');

  static const EventChannel _eventChannel =
  EventChannel('com.persian_flutter/plugin/isCharging');

  const PluginChannel();

  static Future<num> getBatteryLevel([bool asDouble = false]) async =>
      await _methodChannel
          .invokeMethod('getBatteryLevel', {'as_double': asDouble});

  static Future<bool> isLowPowerMode() async =>
      await _methodChannel.invokeMethod('isLowPowerMode');

  static Future<bool> isCharging() async =>
      await _methodChannel.invokeMethod('isCharging');

  static Stream<bool> get isChargingStream =>
      _eventChannel.receiveBroadcastStream().cast();
}
