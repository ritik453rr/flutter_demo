import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

class LocationTrackingService {
  LocationTrackingService._();

  static final LocationTrackingService instance = LocationTrackingService._();

  final FlutterBackgroundService _backgroundService =
      FlutterBackgroundService();

  Future<void> startTracking() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('❌ Location services are disabled.');
        return;
      }
      final isRunning = await _backgroundService.isRunning();

      if (isRunning) {
        _backgroundService.invoke('startTracking');
        print('✅ Start tracking command sent.');
        return;
      }

      // 4. Listen for the readiness event BEFORE starting the service.
      final ready = Completer<void>();

      final subscription = _backgroundService.on('serviceReady').listen((
        event,
      ) {
        if (!ready.isCompleted) {
          ready.complete();
        }
      });

      try {
        print('Starting background service...');
        final started = await _backgroundService.startService();
        if (!started) {
          print('❌ Failed to start the background service.');
          return;
        }
        // 5. Wait for the background isolate to register its listeners.
        await ready.future.timeout(const Duration(seconds: 15));
        // 6. Start location updates.
        _backgroundService.invoke('startTracking');

        print('✅ Location tracking started.');
      } on TimeoutException {
        print('❌ Background service readiness timed out.');
      } finally {
        await subscription.cancel();
      }
    } catch (error, stackTrace) {
      print('❌ Failed to start location tracking: $error');
      print(stackTrace);
    }
  }

  Future<void> stopTracking() async {
    try {
      final isRunning = await _backgroundService.isRunning();

      if (!isRunning) {
        print('Background service is not running.');
        return;
      }
      _backgroundService.invoke('stopTracking');
      print('🛑 Stop tracking command sent.');
    } catch (error) {
      print('❌ Failed to stop location tracking: $error');
    }
  }
}
