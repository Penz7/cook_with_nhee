import 'package:cook_with_nhee/network/models/new_detail_model.dart';
import 'package:cook_with_nhee/network/provider/api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsDetailController extends GetxController {
  final ApiClient _apiClient;

  NewsDetailController(this._apiClient);

  final RxBool isLoading = false.obs;
  final Rx<NewDetailModel?> newsDetail = Rx<NewDetailModel?>(null);
  final RxString errorMessage = ''.obs;
  final ScrollController scrollController = ScrollController();
  final RxBool showScrollToTop = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_handleScrollPosition);
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      final link = args['link'] as String?;
      if (link != null && link.isNotEmpty) {
        fetchNewsDetail(link);
      } else {
        errorMessage.value = 'Không có link bài viết';
      }
    } else if (args is String) {
      fetchNewsDetail(args);
    } else {
      errorMessage.value = 'Thiếu thông tin bài viết';
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_handleScrollPosition);
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchNewsDetail(String link) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final encodedLink = Uri.encodeComponent(link);
      final response = await _apiClient.getNewsDetail(encodedLink);

      if (response.status == 200 || response.status == 201) {
        newsDetail.value = response.data;
      } else {
        errorMessage.value = response.message ?? 'Không thể tải bài viết';
      }
    } catch (e) {
      debugPrint('Lỗi tải chi tiết bài viết: $e');
      errorMessage.value = 'Không thể tải bài viết. Vui lòng thử lại.';
    } finally {
      isLoading.value = false;
    }
  }

  void _handleScrollPosition() {
    final shouldShow = scrollController.offset > 250;
    if (shouldShow != showScrollToTop.value) {
      showScrollToTop.value = shouldShow;
    }
  }

  void scrollToTop() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
