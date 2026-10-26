import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  AppToast._();

  static void showToast({required String message, bool isSuccess = true}) {
    toastification.show(
      type: isSuccess ? ToastificationType.success : ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
      closeButton: const ToastCloseButton(showType: CloseButtonShowType.none),
      title: Text(isSuccess ? 'Success' : 'Error'),
      description: Text(message),
    );
  }
}
