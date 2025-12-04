import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Helper to show custom GetX snackbars with unified style.
class AppToast {
  AppToast._();

  static void success(
    String title,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    _show(
      title,
      message,
      backgroundColor: Colors.green.shade100,
      textColor: Colors.green.shade900,
      icon: Icons.check_circle,
      duration: duration,
    );
  }

  static void error(
    String title,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      title,
      message,
      backgroundColor: Colors.red.shade100,
      textColor: Colors.red.shade900,
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  static void info(
    String title,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    _show(
      title,
      message,
      backgroundColor: Colors.blue.shade100,
      textColor: Colors.blue.shade900,
      icon: Icons.info_outline,
      duration: duration,
    );
  }

  static void _show(
    String title,
    String message, {
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    required Duration duration,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: textColor,
      duration: duration,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: Icon(
        icon,
        color: textColor,
      ),
    );
  }
}


