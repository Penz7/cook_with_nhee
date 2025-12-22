import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../commons/routes/route.dart';
import '../../controller/auth_controller.dart';

class SplashController extends GetxController {
  final AuthController authController;

  SplashController(this.authController);

  static const int timeSplash = 3;
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
        Get.offAllNamed(Routes.home.p);
      } else {
        Get.offAllNamed(Routes.auth.p);
      }
    } catch (e, stackTrace) {
      debugPrint("[SPLASH] Lỗi: $e");
      debugPrint("[SPLASH] Stack trace: $stackTrace");
      Get.offAllNamed(Routes.auth.p);
    }
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  Future<bool> _checkAuthenticationStatus() async {
    try {
      final isTokenValid = await authController.checkAuth();
      if (!isTokenValid) {
        debugPrint("[SPLASH] Token expired or invalid");
        return false;
      }
      if (!authController.isAuth) {
        debugPrint("[SPLASH] Token valid but no user in memory, syncing from server");
        try {
          final user = await authController.getMe();
          if (user == null) {
            debugPrint("[SPLASH] Failed to load user data from server");
            return false;
          }
          debugPrint("[SPLASH] User data loaded from server successfully");
          return true;
        } catch (e) {
          debugPrint("[SPLASH] Failed to sync user data from server: $e");
          return false;
        }
      }
      try {
        await authController.getMe();
        debugPrint("[SPLASH] User data synced successfully");
      } catch (e) {
        debugPrint("[SPLASH] Failed to sync user data (keeping existing): $e");
      }

      return true;
    } catch (e) {
      debugPrint("[SPLASH] Error checking auth status: $e");
      return false;
    }
  }
}
