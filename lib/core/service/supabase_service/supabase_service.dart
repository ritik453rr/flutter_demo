import 'dart:async';

import 'package:demo/core/storage/app_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._internal();

  static final SupabaseService instance = SupabaseService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  StreamSubscription<AuthState>? _authSubscription;

  bool _handlingLogout = false;

  /// Start listening for authentication changes.
  void startSessionMonitoring() {
    _authSubscription?.cancel();

    _authSubscription = _client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        AppStorage.logout();
      }
    });
  }

  /// Validate the session when the app resumes.
  Future<void> validateSession() async {
    if (_handlingLogout) return;

    try {
      final currentSession = _client.auth.currentSession;

      if (currentSession == null) {
        await _handleInvalidSession();
        return;
      }

      // Attempt to refresh the session with the server.
      final response = await _client.auth.refreshSession();

      if (response.session == null) {
        await _handleInvalidSession();
      }
    } on AuthException {
      await _handleInvalidSession();
    } catch (_) {
      // A network failure does not necessarily mean the session is invalid.
      // Do not force logout solely because the device is offline.
    }
  }

  Future<void> _handleInvalidSession() async {
    if (_handlingLogout) return;

    _handlingLogout = true;

    try {
      AppStorage.logout();
    } finally {
      _handlingLogout = false;
    }
  }

  void stopSessionMonitoring() {
    _authSubscription?.cancel();
    _authSubscription = null;
  }
}
