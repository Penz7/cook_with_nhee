import 'package:cook_with_nhee/features/splash/splash_controller.dart';
import 'package:cook_with_nhee/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../commons/widgets/app/app_text.dart';
import '../../commons/widgets/app/primary_scaffold.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(Get.find()));
  }
}

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      backgroundColor: BoxDecoration(color: const Color(0xfffaf5eb)),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Assets.images.appSplash.image(
                fit: BoxFit.contain,
              ),
            ),
            Obx(
              () => AppText.regular(
                "${controller.countdown.value}s",
                fontSize: 13,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
