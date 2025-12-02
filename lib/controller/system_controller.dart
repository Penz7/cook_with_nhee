import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SystemController extends GetxController {

  Future<SystemController> init() async {
    return this;
  }

  DateTime? _backgroundTime;
  final List<Function> _onChangeLocale = [];

  void onChangeLocale(Function callback) {
    _onChangeLocale.add(callback);
  }

  void changeLocale(Locale locale) {
    Get.updateLocale(locale);
    for (var element in _onChangeLocale) {
      element();
    }
  }

  void onAppBackground() {
    log('onAppBackground');
    _backgroundTime = DateTime.now();
  }

  Future<void> onAppForeground() async {
    log('onAppForeground');
    if (_backgroundTime != null) {
      final now = DateTime.now();
      final difference = now.difference(_backgroundTime!);
      if (difference.inMinutes > 1) {
        log('onAppForeground over a minute');
      }
      _backgroundTime = null;
    }
  }
}
