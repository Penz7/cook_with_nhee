
import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:cook_with_nhee/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/models/recipe_model.dart';
import '../../network/provider/api_client.dart';

class HomeController extends GetxController {
  final AuthController authController;
  final ApiClient _apiClient;

  HomeController(this.authController, this._apiClient) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        getRecipeOfDay(),
        getRecommendationRecipes(),
        authController.loadSavedRecipes(),
      ]);
    });
  }


  final RxBool isLoading = false.obs;
  final RxList<RecipeModel> recipes = <RecipeModel>[].obs;
  final RxString ingredients = ''.obs;

  final RxBool isLoadingRecipeOfDay = false.obs;

  final Rx<RecipeModel?> recipeOfDay = Rx<RecipeModel?>(null);

  final RxBool isLoadingRecommendations = false.obs;
  final RxList<RecipeModel> recommendationRecipes = <RecipeModel>[].obs;

  bool get isInitialDataLoaded =>
      !isLoadingRecipeOfDay.value && !isLoadingRecommendations.value;

  Future<void> loadSavedRecipes() async {
    await authController.loadSavedRecipes();
  }


  Future<void> getMagicRecipe() async {
    if (ingredients.value.trim().isEmpty) {
      AppToast.info(
        'Thiếu nguyên liệu',
        'Vui lòng thêm ít nhất một nguyên liệu trước khi tạo công thức.',
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiClient.getMagicRecipes(ingredients.value);

      recipes.value = response;
      await authController.getMe();
    } catch (e) {
      debugPrint('Lỗi gọi API: $e');
      recipes.value = [];
      AppToast.error('Lỗi', 'Không thể tạo công thức. Vui lòng thử lại.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveRecipe(RecipeModel recipe) async {
    await authController.saveRecipe(recipe);
  }

  bool isSavingRecipe(RecipeModel recipe) {
    return authController.isSavingRecipe(recipe);
  }

  bool isRecipeSaved(RecipeModel recipe) {
    return authController.isRecipeSaved(recipe);
  }


  Future<void> getRecipeOfDay() async {
    try {
      isLoadingRecipeOfDay.value = true;
      final response = await _apiClient.getRecipeOfDay();
      if (response.isNotEmpty) {
        recipeOfDay.value = response.first;
      } else {
        recipeOfDay.value = null;
      }
    } catch (e) {
      debugPrint('Lỗi lấy công thức của ngày: $e');
      recipeOfDay.value = null;
    } finally {
      isLoadingRecipeOfDay.value = false;
    }
  }

  Future<void> getRecommendationRecipes() async {
    try {
      isLoadingRecommendations.value = true;
      final response = await _apiClient.getRecommendationRecipes();
      recommendationRecipes.value = response;
    } catch (e) {
      debugPrint('Lỗi lấy danh sách công thức đề xuất: $e');
      recommendationRecipes.value = [];
    } finally {
      isLoadingRecommendations.value = false;
    }
  }

  Future<void> refreshHomeData() async {
    await Future.wait([
      getRecipeOfDay(),
      getRecommendationRecipes(),
    ]);
  }
}
