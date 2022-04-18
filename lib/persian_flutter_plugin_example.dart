import 'dart:async';

import 'package:persian_flutter_plugin_example/plugin_channel.dart';
import 'package:persian_flutter_plugin_example/plugin_ffi_bridge.dart';

class PersianFlutterPluginExample {
  static late final _ffiBridge = PluginFFIBridge();

  static Future<num> getBatteryLevel([bool asDouble = false]) =>
      PluginChannel.getBatteryLevel(asDouble);

  static Future<bool> isLowPowerMode() => PluginChannel.isLowPowerMode();

  static Future<bool> isCharging() => PluginChannel.isCharging();

  static Stream<bool> get isChargingStream => PluginChannel.isChargingStream;

  static String getSuggestion(double batteryLevel, bool isLowPowerMode) =>
      _ffiBridge.getSuggestion(batteryLevel, isLowPowerMode);
}
