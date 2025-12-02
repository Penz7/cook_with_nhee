import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/constants/collections.dart';
import '../../network/models/recipe_model.dart';
import '../../network/provider/api_client.dart';
import '../../network/services/firestore_service.dart';

class HomeController extends GetxController {
  final FirestoreService _firestoreService;
  final ApiClient _apiClient;

  HomeController(this._firestoreService, this._apiClient) {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  final RxBool isLoading = false.obs;
  // final RxList<TagModel> listTag = <TagModel>[].obs;
  final RxList<RecipeModel> recipes = <RecipeModel>[].obs;
  final RxString ingredients = ''.obs;

  // Future<void> loadData() async {
  //   try {
  //     isLoading.value = true;
  //     listTag.value = await _firestoreService.readList<TagModel>(
  //       Collections.tags,
  //       TagModel.fromDocument,
  //     );
  //   } catch (e) {
  //     debugPrint('Không thể lấy được danh sách tag, $e}');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> getMagicRecipe() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.getMagicRecipes(ingredients.value);

      recipes.value = response;
    } catch (e) {
      debugPrint('Lỗi gọi API: $e');
      recipes.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}
