package com.persian_flutter.persian_flutter_plugin_example

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.PowerManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class PersianFlutterPluginExamplePlugin : FlutterPlugin, MethodCallHandler, StreamHandler {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var applicationContext: Context
    private var chargingStateChangeReceiver: BroadcastReceiver? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        methodChannel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "com.persian_flutter/plugin"
        )
        eventChannel =
            EventChannel(
                flutterPluginBinding.binaryMessenger,
                "com.persian_flutter/plugin/isCharging"
            )
        methodChannel.setMethodCallHandler(this)
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "isLowPowerMode" -> {
                val powerManager: PowerManager =
                    applicationContext.getSystemService(Context.POWER_SERVICE) as PowerManager
                val powerSaveMode: Boolean = powerManager.isPowerSaveMode
                result.success(powerSaveMode)
            }
            "getBatteryLevel" -> {
                val asDouble = call.argument<Boolean>("as_Double") ?: false
                val batteryManager: BatteryManager =
                    applicationContext.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
                val batteryLevel =
                    batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
                result.success(
                    when (asDouble) {
                        true -> batteryLevel.toDouble() / 100
                        false -> batteryLevel
                    }
                )
            }
            "isCharging" -> {
                result.success(isCharging())
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        chargingStateChangeReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val status: Int = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
                events?.success(status == BatteryManager.BATTERY_STATUS_CHARGING)
            }
        }
        applicationContext.registerReceiver(
            chargingStateChangeReceiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        )
        events?.success(isCharging())
    }

    override fun onCancel(arguments: Any?) {
        applicationContext.unregisterReceiver(chargingStateChangeReceiver)
    }

    private fun isCharging(): Boolean {
        val batteryManager: BatteryManager =
            applicationContext.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_STATUS) == BatteryManager.BATTERY_STATUS_CHARGING
    }
}