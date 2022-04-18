package com.persian_flutter.persian_flutter_plugin_example

import android.content.Context
import android.os.BatteryManager
import android.os.PowerManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin

class PersianFlutterPluginExamplePlugin : FlutterPlugin,
    PluginMethodChannel.PluginMethodChannelAPI {
    private lateinit var applicationContext: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        PluginMethodChannel.PluginMethodChannelAPI.setup(flutterPluginBinding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        PluginMethodChannel.PluginMethodChannelAPI.setup(binding.binaryMessenger, null)
    }

    override fun getBatteryLevel(asDouble: Boolean): Double {
        val batteryManager: BatteryManager =
            applicationContext.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val batteryLevel =
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY).toDouble()
        return when (asDouble) {
            true -> batteryLevel / 100
            false -> batteryLevel
        }
    }

    override fun isLowPowerMode(): Boolean {
        val powerManager: PowerManager =
            applicationContext.getSystemService(Context.POWER_SERVICE) as PowerManager
        return powerManager.isPowerSaveMode
    }

    override fun isCharging(): Boolean {
        val batteryManager: BatteryManager =
            applicationContext.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_STATUS) == BatteryManager.BATTERY_STATUS_CHARGING
    }
}