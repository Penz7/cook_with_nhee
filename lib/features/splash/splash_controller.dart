import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../commons/routes/route.dart';
import '../../controller/auth_controller.dart';

class SplashController extends GetxController {
  final AuthController authController;

  SplashController(this.authController);

  static const int timeSplash = 5;
  var countdown = timeSplash.obs;
  late Timer timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel();
        navigateToNextScreen();
      }
    });
  }

  void navigateToNextScreen() async {
    try {
      final isAuthenticated = await _checkAuthenticationStatus();

      if (isAuthenticated) {
        debugPrint("[SPLASH] User is authenticated, navigating to main");
        Get.offAllNamed(Routes.home.p);
      } else {
        debugPrint("[SPLASH] User not authenticated, navigating to auth");
        Get.offAllNamed(Routes.login.p);
      }
    } catch (e, stackTrace) {
      debugPrint("[SPLASH] Error: $e");
      debugPrint("[SPLASH] Stack trace: $stackTrace");
      Get.offAllNamed(Routes.login.p);
    }
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  Future<bool> _checkAuthenticationStatus() async {
    try {
      if (!authController.isAuth) {
        debugPrint("[SPLASH] No current user found");
        return false;
      }

      final isTokenValid = await authController.checkAuth();
      if (!isTokenValid) {
        debugPrint("[SPLASH] Token expired or invalid");
        return false;
      }

      try {
        await authController.getMe();
        debugPrint("[SPLASH] User data synced successfully");
      } catch (e) {
        debugPrint("[SPLASH] Failed to sync user data: $e");
      }

      return true;
    } catch (e) {
      debugPrint("[SPLASH] Error checking auth status: $e");
      return false;
    }
  }
}
