import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/extension/sized_box_extension.dart';
import '../../core/service/location_service/location_tracking_service.dart';
import '../number_picker/number_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTiming = 15;

  static const Color _primaryAccent = Color(0xFFD4FE00);
  static const Color _backButtonBg = Color(0xFF22281D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    LocationPermission permission =
                        await Geolocator.checkPermission();
                    if (permission != LocationPermission.always) {
                      openAppSettings();
                    } else {
                      await LocationTrackingService.instance.startTracking();
                    }
                  },
                  child: const Text('Start Tracking'),
                ),

                20.h,

                ElevatedButton(
                  onPressed: () async {
                    await LocationTrackingService.instance.stopTracking();
                  },
                  child: const Text('Stop Tracking'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
