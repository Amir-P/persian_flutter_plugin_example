import 'dart:async';

import 'package:persian_flutter_plugin_example/plugin_ffi_bridge.dart';
import 'package:persian_flutter_plugin_example/plugin_method_channel.dart';

class PersianFlutterPluginExample {
  static late final _ffiBridge = PluginFFIBridge();
  static late final _pluginMethodChannel = PluginMethodChannelAPI();

  static Future<num> getBatteryLevel([bool asDouble = false]) =>
      _pluginMethodChannel.getBatteryLevel(asDouble);

  static Future<bool> isLowPowerMode() => _pluginMethodChannel.isLowPowerMode();

  static Future<bool> isCharging() => _pluginMethodChannel.isCharging();

  static String getSuggestion(double batteryLevel, bool isLowPowerMode) =>
      _ffiBridge.getSuggestion(batteryLevel, isLowPowerMode);
}
