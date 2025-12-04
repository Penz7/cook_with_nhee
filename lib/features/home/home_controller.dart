
import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:cook_with_nhee/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/models/recipe_model.dart';
import '../../network/models/recipe_model_extension.dart';
import '../../network/provider/api_client.dart';

class HomeController extends GetxController {
  final AuthController authController;
  final ApiClient _apiClient;

  HomeController(this.authController, this._apiClient) {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  final RxBool isLoading = false.obs;
  final RxList<RecipeModel> recipes = <RecipeModel>[].obs;
  final RxString ingredients = ''.obs;
  final RxMap<String, bool> savingRecipes = <String, bool>{}.obs;
  final RxSet<String> savedRecipes = <String>{}.obs;

  Future<void> getMagicRecipe() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.getMagicRecipes(ingredients.value);

      recipes.value = response;
      savingRecipes.clear();
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
    final recipeKey = recipe.name ?? '';
    if (recipeKey.isEmpty) return;

    try {
      savingRecipes[recipeKey] = true;
      final recipeFromApi = recipe.toRecipeFromApiModel();
      final response = await _apiClient.saveRecipe(recipeFromApi);
      if (response.status == 200 || response.status == 201) {
        savedRecipes.add(recipeKey);
        AppToast.success(
          'Thành công',
          'Đã lưu công thức "${recipe.name}" vào danh sách của bạn',
        );
      }
    } catch (e) {
      debugPrint('Lỗi lưu recipe: $e');
      AppToast.error(
        'Lỗi',
        'Không thể lưu công thức. Vui lòng thử lại.',
      );
    } finally {
      savingRecipes[recipeKey] = false;
    }
  }

  bool isSavingRecipe(RecipeModel recipe) {
    final recipeKey = recipe.name ?? '';
    return savingRecipes[recipeKey] ?? false;
  }

  bool isRecipeSaved(RecipeModel recipe) {
    final recipeKey = recipe.name ?? '';
    return savedRecipes.contains(recipeKey);
  }
}
