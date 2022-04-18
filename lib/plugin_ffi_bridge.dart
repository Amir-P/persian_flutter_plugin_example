import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

typedef SuggestionFunction = Pointer<Utf8> Function(double, bool);
typedef SuggestionFunctionFFI = Pointer<Utf8> Function(Double, Bool);

class PluginFFIBridge {
  late final SuggestionFunction _getSuggestion;

  PluginFFIBridge() {
    final lib = Platform.isAndroid
        ? DynamicLibrary.open('libpersian_flutter_plugin_example.so')
        : DynamicLibrary.process();

    _getSuggestion =
        lib.lookupFunction<SuggestionFunctionFFI, SuggestionFunction>(
            'get_suggestion');
  }

  String getSuggestion(double batteryLevel, bool isLowPowerMode) {
    final ptr = _getSuggestion(batteryLevel, isLowPowerMode);
    final suggestion = ptr.toDartString();
    // calloc.free(ptr);
    return suggestion;
  }
}
