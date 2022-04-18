import Flutter
import UIKit

public class SwiftPersianFlutterPluginExamplePlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "com.persian_flutter/plugin", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "com.persian_flutter/plugin/isCharging", binaryMessenger: registrar.messenger())
        let instance = SwiftPersianFlutterPluginExamplePlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "isLowPowerMode" {
            result(ProcessInfo.processInfo.isLowPowerModeEnabled)
        } else if call.method == "getBatteryLevel" {
            var device = UIDevice.current
            device.isBatteryMonitoringEnabled = true
            if device.batteryState == .unknown {
                result(-1)
            } else {
                result(Int(device.batteryLevel * 100))
            }
        } else if call.method == "isCharging" {
            var device = UIDevice.current
            device.isBatteryMonitoringEnabled = true
            result(isCharging())
        }
    }

    public func onListen(withArguments arguments: Any?,
                         eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        UIDevice.current.isBatteryMonitoringEnabled = true
        eventSink(isCharging())
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onBatteryStateDidChange),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil)
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
    }

    @objc private func onBatteryStateDidChange(notification: NSNotification) {
        eventSink?(isCharging())
    }

    private func isCharging() -> Bool {
        return UIDevice.current.batteryState == .charging
    }
}
