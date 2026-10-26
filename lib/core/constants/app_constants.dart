import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
