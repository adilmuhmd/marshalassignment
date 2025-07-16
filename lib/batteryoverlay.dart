import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryOverlay extends StatefulWidget {
  const BatteryOverlay({super.key});

  @override
  State<BatteryOverlay> createState() => _BatteryOverlayState();
}

class _BatteryOverlayState extends State<BatteryOverlay> {
  static const EventChannel _batteryChannel =
  EventChannel('samples.flutter.dev/battery');

  StreamSubscription? _batterySubscription;
  int _batteryLevel = 100;

  @override
  void initState() {
    super.initState();
    _batterySubscription = _batteryChannel.receiveBroadcastStream().listen((event) {
      setState(() {
        _batteryLevel = event;
      });
    }, onError: (error) {
      print('Battery status error: $error');
    });
  }

  @override
  void dispose() {
    _batterySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          // color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.battery_full, color: Colors.greenAccent),
            const SizedBox(width: 6),
            Text('$_batteryLevel%', style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
