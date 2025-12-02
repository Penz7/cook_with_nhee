import 'dart:async';
import 'package:get/get.dart';

import '../../commons/routes/route.dart';

class SplashController extends GetxController {
  static const int timeSplash = 10;
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

  void navigateToNextScreen() {
    Get.offAllNamed(Routes.main.p);
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }
}
