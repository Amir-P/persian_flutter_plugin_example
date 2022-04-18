import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class PluginMethodChannelAPI {
  double getBatteryLevel(bool asDouble);

  bool isLowPowerMode();

  bool isCharging();
}