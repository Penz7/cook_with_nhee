import 'package:cook_with_nhee/features/splash/splash_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.pink.shade50,
                Colors.pink.shade100.withOpacity(0.5),
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
                      color: Colors.pink.shade100.withOpacity(0.7),
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
              const SizedBox(height: 24),
              const Text(
                "Nhee Cooking",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Đang chuẩn bị công thức ngon cho bạn...",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.pink.shade400,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => Text(
                  "Sẵn sàng sau ${controller.countdown.value}s",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.pink.shade300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
