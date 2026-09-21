import 'package:flutter/material.dart';

class CustomFlushBar {
  static void show(
    BuildContext context, {
    required String msg,
  }) {
    final overlayState = Overlay.of(context);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        final paddingTop = MediaQuery.of(context).padding.top;

        return Positioned(
          top: paddingTop + 10,
          left: 14,
          right: 14,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.green, // Replace with AppColors.c65DB61
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                msg,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black, // Replace with AppColors.c000000
                ),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }
}