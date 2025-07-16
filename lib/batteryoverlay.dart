import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryOverlay extends StatefulWidget {
  final bool isVisible;
  const BatteryOverlay({super.key, required this.isVisible});

  @override
  State<BatteryOverlay> createState() => _BatteryOverlayState();
}

class _BatteryOverlayState extends State<BatteryOverlay> {
  static const EventChannel _batteryChannel = EventChannel('samples.flutter.dev/battery');
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
    if (!widget.isVisible) return const SizedBox.shrink();

    return Positioned(
      top: 720,
      left: MediaQuery.of(context).size.width * 0.2,
      right: MediaQuery.of(context).size.width * 0.2,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.85),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _batteryLevel >= 80
                  ? Icons.battery_full
                  : _batteryLevel >= 50
                  ? Icons.battery_5_bar
                  : _batteryLevel >= 20
                  ? Icons.battery_2_bar
                  : Icons.battery_alert,
              color: _batteryLevel > 20 ? Colors.greenAccent : Colors.redAccent,
            ),
            const SizedBox(width: 8),
            Text(
              '$_batteryLevel%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
