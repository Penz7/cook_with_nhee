import 'package:cook_with_nhee/controller/auth_controller.dart';
import 'package:cook_with_nhee/network/models/new_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/provider/api_client.dart';

class DiscoverController extends GetxController {
  final AuthController authController;
  final ApiClient _apiClient;

  DiscoverController(this.authController, this._apiClient) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getListNews();
    });
  }

  final RxBool isLoading = false.obs;
  final RxBool isPaging = false.obs;
  final RxInt page = 1.obs;
  final Rx<NewModel?> featuredNews = Rx<NewModel?>(null);
  final RxList<NewModel> news = <NewModel>[].obs;
  final RxBool hasMore = true.obs;

  // Lưu category value để gọi API
  final RxString category = 'All'.obs;
  // Lưu category key để hiển thị trong filter UI
  final RxString categoryKey = 'All'.obs;

  static const List<Map<String, String>> filters = [
    {'key': 'Tất cả', 'value': 'All'},
    {'key': 'Thiếu nhi', 'value': 'children'},
    {'key': 'Thực phẩm và Thể hình', 'value': 'category-food-and-fitness'},
    {'key': 'Sống lành mạnh', 'value': 'healthy-living'},
    {'key': "Sức khỏe phụ nữ", 'value': 'category-womens-health'},
    {'key': 'Những câu chuyện từ trái tim', 'value': 'stories-from-the-heart'},
  ];

  Future<void> changeCategory(String newCategoryValue) async {
    if (category.value == newCategoryValue) return;
    category.value = newCategoryValue;
    final filter = filters.firstWhere(
      (e) => e['value'] == newCategoryValue,
      orElse: () => filters[0],
    );
    categoryKey.value = filter['key']!;
    page.value = 1;
    hasMore.value = true;
    featuredNews.value = null;
    news.clear();
    await getListNews();
  }

  Future<void> nextPage() async {
    if (isLoading.value || isPaging.value || !hasMore.value) return;
    await getListNews(targetPage: page.value + 1);
  }

  Future<void> previousPage() async {
    if (isLoading.value || isPaging.value || page.value <= 1) return;
    await getListNews(targetPage: page.value - 1);
  }

  Future<void> getListNews({int? targetPage}) async {
    if (isLoading.value || isPaging.value) return;
    try {
      final requestedPage = targetPage ?? page.value;
      if (requestedPage < 1) {
        return;
      }

      final isInitialLoad = requestedPage == 1;
      if (isInitialLoad) {
        isLoading.value = true;
      } else {
        isPaging.value = true;
      }

      final response = category.value == 'All'
          ? await _apiClient.getNews(requestedPage)
          : await _apiClient.getNewsByCategory(category.value, requestedPage);

      final List<NewModel> list = response.data ?? [];

      if (list.isNotEmpty) {
        if (requestedPage == 1) {
          featuredNews.value = list.first;
          news.value = list.length > 1 ? list.sublist(1) : [];
          hasMore.value = list.length > 1;
        } else {
          news.value = list;
          hasMore.value = true;
        }
        page.value = requestedPage;
      } else {
        if (requestedPage == 1) {
          featuredNews.value = null;
          news.clear();
        }
        hasMore.value = false;
      }
    } catch (e) {
      debugPrint('Lỗi lấy danh sách news: $e');
      if (targetPage == null || targetPage == 1) {
        featuredNews.value = null;
        news.clear();
      }
    } finally {
      isLoading.value = false;
      isPaging.value = false;
    }
  }

  Future<void> refreshNews() async {
    page.value = 1;
    hasMore.value = true;
    featuredNews.value = null;
    news.clear();
    await getListNews(targetPage: 1);
  }
}

