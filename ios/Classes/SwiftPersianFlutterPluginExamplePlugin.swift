import Flutter
import UIKit

public class SwiftPersianFlutterPluginExamplePlugin: NSObject, FlutterPlugin, PluginMethodChannelAPI {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftPersianFlutterPluginExamplePlugin()
        PluginMethodChannelAPISetup(registrar.messenger(), instance);
    }
    
    public func getBatteryLevel(asDouble: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == .unknown {
            return -1
        } else {
            let batteryLevel = device.batteryLevel
            return (asDouble.boolValue ? batteryLevel : batteryLevel * 100) as NSNumber
        }
    }
    
    public func isLowPowerModeWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
        return ProcessInfo.processInfo.isLowPowerModeEnabled as NSNumber?
    }
    
    public func isChargingWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
        return (UIDevice.current.batteryState == .charging) as NSNumber
    }
}
