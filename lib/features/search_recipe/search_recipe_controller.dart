import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:cook_with_nhee/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/models/recipe_model.dart';
import '../../network/provider/api_client.dart';

class SearchRecipeController extends GetxController {
  final AuthController authController;
  final ApiClient _apiClient;

  SearchRecipeController(this.authController, this._apiClient);

  final RxBool isLoading = false.obs;
  final RxList<RecipeModel> recipes = <RecipeModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxMap<String, bool> savingRecipes = <String, bool>{}.obs;
  final RxSet<String> savedRecipes = <String>{}.obs;
  late final TextEditingController searchTextController;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    final initialQuery = args != null && args.containsKey('query')
        ? args['query'] as String
        : '';
    searchTextController = TextEditingController(text: initialQuery);
    if (initialQuery.isNotEmpty) {
      searchQuery.value = initialQuery;
      searchRecipes(initialQuery);
    }
    loadSavedRecipes();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  Future<void> loadSavedRecipes() async {
    try {
      final response = await _apiClient.getMyRecipes();
      final data = response.data;
      if ((response.status == 200 || response.status == 201) && data != null) {
        savedRecipes
          ..clear()
          ..addAll(data.map((item) => item.name).whereType<String>());
      }
    } catch (e) {
      debugPrint('Lỗi tải công thức đã lưu: $e');
    }
  }

  Future<void> searchRecipes(String query) async {
    if (query.trim().isEmpty) {
      recipes.value = [];
      return;
    }

    try {
      isLoading.value = true;
      searchQuery.value = query;
      final bmi =
          (Get.find<AuthController>().currentUser?.userMeasurement?.bmi ?? 20)
              .toDouble();
      final response = await _apiClient.searchRecipes(query, bmi);
      recipes.value = response;

      if (recipes.isEmpty) {
        AppToast.info(
          'Không tìm thấy',
          'Không có công thức nào phù hợp với từ khóa "$query"',
        );
      }
    } catch (e) {
      debugPrint('Lỗi tìm kiếm công thức: $e');
      recipes.value = [];
      AppToast.error('Lỗi', 'Không thể tìm kiếm công thức. Vui lòng thử lại.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveRecipe(RecipeModel recipe) async {
    final recipeKey = recipe.name ?? '';
    if (recipeKey.isEmpty) return;

    try {
      savingRecipes[recipeKey] = true;
      final response = await _apiClient.saveRecipe(recipe);
      if (response.status == 200 || response.status == 201) {
        savedRecipes.add(recipeKey);
        AppToast.success(
          'Thành công',
          'Đã lưu công thức "${recipe.name}" vào danh sách của bạn',
        );
      }
    } catch (e) {
      debugPrint('Lỗi lưu recipe: $e');
      AppToast.error('Lỗi', 'Không thể lưu công thức. Vui lòng thử lại.');
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
