import 'package:cook_with_nhee/network/services/storage_service.dart';
import 'package:get/get.dart';

import '../../commons/routes/route.dart';
import '../../env.dart';
import '../provider/api_client.dart';
import 'firestore_service.dart';
import 'get_http_service.dart';

Future initServices() async {
  Get.put(RouteService());
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(
    () => GetHttpService().init(Get.find<StorageService>(), Env().apiUrl),
  );
  Get.put(ApiClient(Get.find<GetHttpService>()));
  await Get.putAsync(() => FirestoreService().init());
}
