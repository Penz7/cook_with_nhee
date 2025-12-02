import 'package:flutter/material.dart';

extension NumberExtension on num {
  SizedBox get width => SizedBox(
    width: toDouble(),
  );

  SizedBox get height => SizedBox(
    height: toDouble(),
  );

  String get weightFormat {
    if (toInt() >= 1000) return '${this / 1000}kg';
    return '${this}g';
  }
}