import 'package:cook_with_nhee/controller/system_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../network/provider/api_client.dart';
import '../network/services/storage_service.dart';
import 'auth_controller.dart';

Future<void> initControllers() async {
  try {
    await Get.putAsync(
      () => AuthController(
        Get.find<ApiClient>(),
        Get.find<StorageService>(),
      ).init(),
    );
    await Get.putAsync(() => SystemController().init(), permanent: true);
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('[initControllers] ERROR: $e');
      print('[initControllers] StackTrace: $stackTrace');
    }

    rethrow;
  }
}
