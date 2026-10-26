import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../features/auth/login_page.dart';

class AppStorage {
  AppStorage._internal();

  static final GetStorage _storage = GetStorage();

  // KEYS---------------------------------KEYS
  static const String authToken = "authToken";
  static const String loginStatus = "loginStatus";

  /// Initialize GetStorage (call this in main method before runApp)
  static Future<bool> init() async {
    return await GetStorage.init();
  }

  /// Save authentication token
  static Future<void> saveAuthToken(String token) async {
    await _storage.write(authToken, token);
  }

  /// Get authentication token
  static String getAuthToken() {
    return _storage.read(authToken) ?? "";
  }

  static void setLoginStatus(bool value) {
    _storage.write(loginStatus, value);
  }

  static bool getLoginStatus() {
    return _storage.read(loginStatus) ?? false;
  }

  /// Clear stored data and optionally navigate back to LoginPage
  static void logout([BuildContext? context]) {
    _storage.erase();
    if (context != null && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }
}
