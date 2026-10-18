import 'package:bgeo_background_geolocation/bgeo_background_geolocation.dart'
    as bg;
import 'package:demo/core/service/location_service/location_model.dart';
import 'package:flutter/widgets.dart';

class LocationService {
  LocationService._();

  static final LocationService instance = LocationService._();

  bool _initialized = false;
  bool _starting = false;
  DateTime? _lastLocationSentTime;

  Future<void> initialize() async {
    if (_initialized || _starting) return;

    _starting = true;

    try {
      // Listen for location updates.
      bg.BackgroundGeolocation.onLocation((location) {
        debugPrint('========== LOCATION RECEIVED ==========');
        debugPrint('Latitude: ${location.coords.latitude}');
        debugPrint('Longitude: ${location.coords.longitude}');
        debugPrint('Accuracy: ${location.coords.accuracy} meters');
        debugPrint('========================================');

        _processLocationUpdate(location);
      });

      // Listen for heartbeat events (when stationary).
      bg.BackgroundGeolocation.onHeartbeat((event) async {
        debugPrint('========== LOCATION HEARTBEAT ==========');
        try {
          final location = await bg.BackgroundGeolocation.getCurrentPosition();
          _processLocationUpdate(location);
        } catch (e) {
          debugPrint('Error getting current location on heartbeat: $e');
        }
      });

      // Listen for location errors.
      bg.BackgroundGeolocation.onLocationError((error) {
        debugPrint('BACKGROUND LOCATION ERROR: $error');
      });

      // Initialize the plugin.
      await bg.BackgroundGeolocation.ready(
        bg.Config(
          desiredAccuracy: bg.desiredAccuracyHigh,
          distanceFilter: 0,
          locationUpdateInterval: 60000,
          // 1 minute (in ms)
          heartbeatInterval: 60,
          // 1 minute (in seconds)
          stopOnTerminate: false,
          startOnBoot: true,
        ),
      );

      _initialized = true;
      debugPrint('Background geolocation initialized.');
      await startTracking();
    } catch (e, stackTrace) {
      debugPrint('Location service initialization failed: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _starting = false;
    }
  }

  Future<void> _processLocationUpdate(bg.Location location) async {
    final now = DateTime.now();

    // Check if 1 minute has passed since last upload
    if (_lastLocationSentTime == null ||
        now.difference(_lastLocationSentTime!) >= const Duration(minutes: 1)) {
      _lastLocationSentTime = now;

      final locationModel = LocationModel(
        latitude: location.coords.latitude,
        longitude: location.coords.longitude,
        accuracy: location.coords.accuracy,
        timestamp: now.toIso8601String(),
      );

      try {
        // Add location send method
        debugPrint('========== LOCATION SENT  ==========');
        debugPrint('Latitude: ${locationModel.latitude}');
        debugPrint('Longitude: ${locationModel.longitude}');
        debugPrint('Accuracy: ${locationModel.accuracy}');
        debugPrint('Timestamp: ${locationModel.timestamp}');
        debugPrint('================================================');
      } catch (e) {
        debugPrint('Error sending location to Firestore: $e');
      }
    }
  }

  Future<void> startTracking() async {
    if (!_initialized) {
      debugPrint('Location service has not been initialized.');
      return;
    }
    final permission = await bg.BackgroundGeolocation.requestPermission();
    if (permission != bg.authorizationStatusAlways) {
      debugPrint(
        'Background location permission is required. '
        'Current status: $permission',
      );
      return;
    }
    await bg.BackgroundGeolocation.start();
    debugPrint('Background location tracking started automatically.');
  }

  Future<void> stopTracking() async {
    await bg.BackgroundGeolocation.stop();
    debugPrint('Background location tracking stopped.');
  }
}
