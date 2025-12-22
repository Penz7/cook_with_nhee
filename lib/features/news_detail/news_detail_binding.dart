import 'package:cook_with_nhee/features/news_detail/news_detail_controller.dart';
import 'package:cook_with_nhee/network/provider/api_client.dart';
import 'package:get/get.dart';

class NewsDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewsDetailController(Get.find<ApiClient>()));
  }
}

