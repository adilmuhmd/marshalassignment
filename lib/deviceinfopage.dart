import 'dart:io';
import 'package:flutter/material.dart';



class DeviceInfoScreen extends StatelessWidget {
  const DeviceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final os = Platform.operatingSystem;
    final osVersion = Platform.operatingSystemVersion;

    return Scaffold(
      appBar: AppBar(title: const Text('Device & App Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('OS: $os', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('OS Version: $osVersion', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
