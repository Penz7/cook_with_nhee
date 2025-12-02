import 'package:cook_with_nhee/controller/system_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

Future<void> initControllers() async {
  try {
    await Get.putAsync(() => SystemController().init(), permanent: true);
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('[initControllers] ERROR: $e');
      print('[initControllers] StackTrace: $stackTrace');
    }

    rethrow;
  }
}
