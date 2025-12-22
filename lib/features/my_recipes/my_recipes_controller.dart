import 'package:cook_with_nhee/network/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/models/api_response_model.dart';
import '../../network/models/recipe_from_api_model.dart';
import '../../network/provider/api_client.dart';
import '../../commons/widgets/app/app_toast.dart';

class MyRecipesController extends GetxController {
  final ApiClient _apiClient;

  MyRecipesController(this._apiClient);

  final RxBool isLoading = false.obs;
  final RxList<RecipeModel> recipes = <RecipeModel>[].obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  Worker? _searchWorker;

  @override
  void onInit() {
    super.onInit();
    loadRecipes();
    _searchWorker = debounce(searchQuery, (_) => loadRecipes(),
        time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    _searchWorker?.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadRecipes() async {
    try {
      if (searchQuery.isEmpty) {
        isLoading.value = true;
      }
      final response = await _apiClient.getMyRecipes(name: searchQuery.value);
      if (response.status == 200 && response.data != null) {
        recipes.assignAll(response.data!);
      } else {
        recipes.clear();
      }
    } catch (e) {
      debugPrint('Lỗi lấy danh sách recipes: $e');
      recipes.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    if (value.isEmpty) {
      loadRecipes();
    }
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    loadRecipes();
  }

  Future<bool> deleteRecipe(String id) async {
    try {
      final response = await _apiClient.deleteRecipe(id);
      if (response.status == 200) {
        recipes.removeWhere((element) => element.id == id);
        AppToast.success('Thành công', 'Đã xoá công thức');
        return true;
      }
    } catch (e) {
      debugPrint('Lỗi xoá recipe: $e');
      AppToast.error('Lỗi', 'Không thể xoá công thức');
    }
    return false;
  }

  Future<void> refreshRecipes() async {
    await loadRecipes();
  }
}