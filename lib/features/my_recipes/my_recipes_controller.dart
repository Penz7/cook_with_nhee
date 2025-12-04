import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/models/recipe_from_api_model.dart';
import '../../network/provider/api_client.dart';

class MyRecipesController extends GetxController {
  final ApiClient _apiClient;

  MyRecipesController(this._apiClient);

  final RxBool isLoading = false.obs;
  final RxList<RecipeFromApiModel> recipes = <RecipeFromApiModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.getMyRecipes();
      if (response.status == 200 && response.data != null) {
        recipes.value = response.data!;
      } else {
        recipes.value = [];
      }
    } catch (e) {
      debugPrint('Lỗi lấy danh sách recipes: $e');
      recipes.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshRecipes() async {
    await loadRecipes();
  }
}