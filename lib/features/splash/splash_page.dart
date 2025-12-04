import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/features/splash/splash_controller.dart';
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
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.pink.shade50,
                Colors.pink.shade100.opacityColor(0.5),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade100.opacityColor(0.7),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.pink.shade300,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.restaurant_menu_rounded,
                      size: 34,
                      color: Colors.pink,
                    ),
                  ],
                ),
              ),
              24.height,
              AppText.bold(
                "Nhee Cooking",
                fontSize: 24,
                color: Colors.pink,
              ),
              8.height,
              AppText.regular(
                "Đang chuẩn bị công thức ngon cho bạn...",
                fontSize: 14,
                color: Colors.pink.shade400,
              ),
              12.height,
              Obx(
                () => AppText.regular(
                  "Sẵn sàng sau ${controller.countdown.value}s",
                  fontSize: 13,
                  color: Colors.pink.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
