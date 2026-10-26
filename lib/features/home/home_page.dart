import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/extension/sized_box_extension.dart';
import '../../core/service/location_service/location_tracking_service.dart';
import '../../core/service/supabase_service/supabase_service.dart';
import '../../core/storage/app_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _supabase = Supabase.instance.client;

  Future<void> _logout() async {
    await _supabase.auth.signOut();
    if (mounted) {
      AppStorage.logout(context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SupabaseService.instance.startSessionMonitoring();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SupabaseService.instance.validateSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
