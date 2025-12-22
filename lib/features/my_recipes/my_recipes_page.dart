import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_shimmer.dart';
import 'package:cook_with_nhee/features/discover/components/discover_recipe_card.dart';
import 'package:cook_with_nhee/features/my_recipes/my_recipes_controller.dart';
import 'package:cook_with_nhee/features/recipe_detail/recipe_detail_page.dart';
import 'package:cook_with_nhee/network/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/provider/api_client.dart';

class MyRecipesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyRecipesController(Get.find<ApiClient>()));
  }
}

class MyRecipesPage extends GetView<MyRecipesController> {
  const MyRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      backgroundColor: const BoxDecoration(color: UIColors.creamy),
      body: Obx(() {
        final header = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText.bold(
                    'Món ăn của tôi',
                    fontSize: FontSizes.medium,
                  ),
                ],
              ),
              16.height,
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.opacityColor(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm công thức...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.pink.shade300,
                    ),
                    suffixIcon: Obx(() => controller.searchQuery.isNotEmpty
                        ? GestureDetector(
                            onTap: controller.clearSearch,
                            child: Icon(
                              Icons.cancel,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                          )
                        : const SizedBox.shrink()),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              10.height,
            ],
          ),
        );
        final emptyState = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 80,
                color: Colors.pink.shade200,
              ),
              20.height,
              AppText.regular(
                'Chưa có công thức nào.\nHãy lưu công thức từ trang chủ nhé!',
                textAlign: TextAlign.center,
                fontSize: 16,
                color: Colors.pink.shade400,
              ),
            ],
          ),
        );
        final listHeader = Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: AppText.bold(
            'Công thức đã lưu',
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        );

        return RefreshIndicator(
          onRefresh: controller.refreshRecipes,
          color: UIColors.pink,
          child: _buildContent(header, emptyState, listHeader),
        );
      }),
    );
  }

  Widget _buildContent(Widget header, Widget emptyState, Widget listHeader) {
    if (controller.isLoading.value) {
      return ListView.separated(
        padding: const EdgeInsets.only(bottom: 40),
        itemCount: 6, // Header + 5 shimmer items
        separatorBuilder: (context, index) {
          if (index == 0) return const SizedBox.shrink();
          return const SizedBox(height: 20);
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            return header;
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildShimmerItem(),
          );
        },
      );
    }
    if (controller.recipes.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                children: [
                  header,
                  SizedBox(
                    height: constraints.maxHeight - 150,
                    child: emptyState,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: controller.recipes.length + 2,
      separatorBuilder: (context, index) {
        if (index == 0 || index == 1) return const SizedBox.shrink();
        return const SizedBox(height: 20);
      },
      itemBuilder: (context, index) {
        if (index == 0) {
          return header;
        }
        if (index == 1) {
          return listHeader;
        }

        final recipeIndex = index - 2;
        final recipe = controller.recipes[recipeIndex];
        final calories = _extractCalories(recipe);
        final duration = recipe.cookTime ?? 
            recipe.prepTime ?? 
            recipe.cookingTime ?? 
            '15 min';
        final imageUrl = _resolveImage(recipe.images);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DiscoverRecipeCard(
            title: recipe.name ?? 'Công thức',
            calories: calories,
            duration: duration,
            imageUrl: imageUrl,
            isFavorite: true,
            isSaving: false,
            customActionIcon: Icons.delete_outline,
            onTap: () {
              Get.to(() => RecipeDetailPage(recipe: recipe));
            },
            onToggleFavorite: () {
              if (recipe.id != null) {
                _showDeleteConfirmation(context, recipe);
              }
            },
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, RecipeModel recipe) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            20.height,
            AppText.bold(
              'Xoá công thức?',
              fontSize: 20,
            ),
            12.height,
            AppText.regular(
              'Bạn có chắc chắn muốn xoá công thức "${recipe.name}" không? Hành động này không thể hoàn tác.',
              textAlign: TextAlign.center,
              color: Colors.grey.shade600,
              maxLines: 4,
            ),
            20.height,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: AppText.bold(
                      'Huỷ',
                      fontSize: FontSizes.small,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                16.width,
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      controller.deleteRecipe(recipe.id!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: AppText.bold(
                      'Xoá ngay',
                      fontSize: FontSizes.small,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            20.height,
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.shade100.opacityColor(0.3),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppShimmer.rectangular(
                      width: double.infinity,
                      height: 20,
                    ),
                    8.height,
                    const AppShimmer.rectangular(
                      width: double.infinity,
                      height: 16,
                    ),
                    4.height,
                    const AppShimmer.rectangular(
                      width: 150,
                      height: 16,
                    ),
                  ],
                ),
              ),
              12.width,
              const AppShimmer.rectangular(
                width: 36,
                height: 36,
                borderRadius: 10,
              ),
            ],
          ),
          16.height,
          Row(
            children: [
              const AppShimmer.rectangular(
                width: 80,
                height: 24,
                borderRadius: 12,
              ),
              8.width,
              const AppShimmer.rectangular(
                width: 100,
                height: 24,
                borderRadius: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _extractCalories(RecipeModel recipe) {
    // Try to get from nutrition first
    if (recipe.nutrition?.calories != null) {
      return '${recipe.nutrition!.calories} kcal';
    }
    
    // Fallback to tags
    final tags = recipe.tags ?? [];
    for (final tag in tags) {
      final name = tag.name ?? '';
      if (name.toLowerCase().contains('kcal')) {
        return name;
      }
    }
    return 'N/A kcal';
  }

  String _resolveImage(List<dynamic>? images) {
    if (images == null || images.isEmpty) return '';
    final first = images.first;
    if (first is String) return first;
    return '';
  }
}
