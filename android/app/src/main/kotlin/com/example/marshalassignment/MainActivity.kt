package com.example.marshalassignment

import android.content.*
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
    private val BATTERY_CHANNEL = "samples.flutter.dev/battery"
    private var eventSink: EventChannel.EventSink? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        EventChannel(flutterEngine?.dartExecutor?.binaryMessenger, BATTERY_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                private var batteryReceiver: BroadcastReceiver? = null

                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    batteryReceiver = createBatteryReceiver()
                    registerReceiver(batteryReceiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
                }

                override fun onCancel(arguments: Any?) {
                    unregisterReceiver(batteryReceiver)
                    batteryReceiver = null
                    eventSink = null
                }

                private fun createBatteryReceiver(): BroadcastReceiver {
                    return object : BroadcastReceiver() {
                        override fun onReceive(context: Context?, intent: Intent?) {
                            val level = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
                            val scale = intent?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
                            if (level >= 0 && scale > 0) {
                                val batteryPct = (level * 100) / scale
                                eventSink?.success(batteryPct)
                            }
                        }
                    }
                }
            }
        )
    }
}
