import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:cook_with_nhee/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/models/recipe_model.dart';
import '../../network/provider/api_client.dart';

class CreateRecipeController extends GetxController {
  final AuthController authController;
  final ApiClient _apiClient;

  CreateRecipeController(this.authController, this._apiClient);

  final RxBool isLoading = false.obs;
  final RxList<RecipeModel> recipes = <RecipeModel>[].obs;
  final RxList<String> ingredients = <String>[].obs;


  void addIngredient(String ingredient) {
    if (ingredient.trim().isNotEmpty && !ingredients.contains(ingredient.trim())) {
      ingredients.add(ingredient.trim());
    }
  }

  void removeIngredient(String ingredient) {
    ingredients.remove(ingredient);
  }

  Future<void> generateRecipe() async {
    if (ingredients.isEmpty) {
      AppToast.info(
        'Thiếu nguyên liệu',
        'Vui lòng thêm ít nhất một nguyên liệu trước khi tạo công thức.',
      );
      return;
    }

    try {
      isLoading.value = true;
      final ingredientsString = ingredients.join(', ');
      final response = await _apiClient.getMagicRecipes(ingredientsString);

      recipes.value = response;
      
      if (recipes.isEmpty) {
        AppToast.info(
          'Không tìm thấy công thức',
          'Không có công thức nào phù hợp với nguyên liệu bạn đã chọn.',
        );
      }
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

}

