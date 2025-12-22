import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/features/create_recipe/components/featured_recipe_card.dart';
import 'package:cook_with_nhee/features/create_recipe/create_recipe_controller.dart';
import 'package:cook_with_nhee/features/discover/components/discover_recipe_card.dart';
import 'package:cook_with_nhee/features/recipe_detail/recipe_detail_page.dart';
import 'package:cook_with_nhee/network/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/provider/api_client.dart';

class CreateRecipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CreateRecipeController(Get.find(), Get.find<ApiClient>()),
    );
  }
}

class CreateRecipePage extends GetView<CreateRecipeController> {
  const CreateRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController ingredientController = TextEditingController();

    return PrimaryScaffold(
      backgroundColor: const BoxDecoration(color: UIColors.creamy),
      appBar: AppBar(
        backgroundColor: UIColors.creamy,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_sharp,
            size: 25,
            color: Colors.black87,
          ),
          onPressed: () => Get.back(),
        ),
        title: AppText.bold(
          'Al Chef',
          fontSize: FontSizes.medium,
        ),
      ),
      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            20.height,
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  height: 1.2,
                ),
                children: [
                  TextSpan(text: "Hôm nay trong tủ lạnh\n"),
                  TextSpan(
                    text: 'của bạn có gì?',
                    style: TextStyle(color: UIColors.pink),
                  ),
                ],
              ),
            ),
            24.height,
            _buildSearchBar(ingredientController),
            _buildIngredientList(),
            20.height,
            _buildGenerateButton(),
            if (controller.recipes.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: AppText.bold(
                  'Gợi ý cho bạn',
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // Featured recipe (first one)
              _buildFeaturedRecipe(controller.recipes[0], controller),
              16.height,
              // Remaining recipes
              ...controller.recipes.skip(1).map((recipe) {
                final calories = _extractCalories(recipe);
                final duration = recipe.cookTime ?? recipe.prepTime ?? '15 min';
                final imageUrl = _resolveImage(recipe.images);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DiscoverRecipeCard(
                    title: recipe.name ?? 'Công thức',
                    calories: calories,
                    duration: duration,
                    imageUrl: imageUrl,
                    isFavorite: controller.isRecipeSaved(recipe),
                    isSaving: controller.isSavingRecipe(recipe),
                    onTap: () {
                      Get.to(() => RecipeDetailPage(recipe: recipe));
                    },
                    onToggleFavorite: () {
                      controller.saveRecipe(recipe);
                    },
                  ),
                );
              }),
            ],
            const SizedBox(height: 100),
          ],
        );
      }),
    );
  }

  Widget _buildSearchBar(TextEditingController ingredientController) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.opacityColor(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: UIColors.pink,
            size: 20,
          ),
          12.width,
          Expanded(
            child: TextField(
              controller: ingredientController,
              decoration: InputDecoration(
                hintText: 'Thêm nguyên liệu (ví dụ: Gà)',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: FontSizes.moreSmall,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  controller.addIngredient(value.trim());
                  ingredientController.clear();
                }
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              final value = ingredientController.text.trim();
              if (value.isNotEmpty) {
                controller.addIngredient(value);
                ingredientController.clear();
              }
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: UIColors.pinkLight.opacityColor(0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: UIColors.pink,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientList() {
    if (controller.ingredients.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.ingredients.asMap().entries.map((entry) {
          return _buildIngredientChip(entry.value, entry.key);
        }).toList(),
      ),
    );
  }

  Widget _buildIngredientChip(String ingredient, int index) {
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.green,
    ];
    final colorIndex = index % colors.length;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: colors[colorIndex].opacityColor(0.1),
        border: Border.all(
          color: colors[colorIndex].opacityColor(0.4),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.bold(
            ingredient,
            fontSize: FontSizes.moreSmall,
            color: colors[colorIndex],
          ),
          8.width,
          GestureDetector(
            onTap: () => controller.removeIngredient(ingredient),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.close,
                size: FontSizes.moreSmall,
                color: colors[colorIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.generateRecipe,
        style: ElevatedButton.styleFrom(
          backgroundColor: UIColors.pink,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 2,
          shadowColor: UIColors.pink.opacityColor(0.4),
          surfaceTintColor: UIColors.pink.opacityColor(0.4),
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText.bold(
                    'Tạo công thức',
                    fontSize: FontSizes.small,
                    color: Colors.white,
                  ),
                  10.width,
                  const Icon(Icons.auto_awesome, size: 25),
                ],
              ),
      ),
    );
  }

  Widget _buildFeaturedRecipe(RecipeModel recipe, CreateRecipeController controller) {
    final calories = _extractCalories(recipe);
    final duration = recipe.cookTime ?? recipe.prepTime ?? recipe.cookingTime ?? '15 min';
    final difficulty = recipe.difficulty ?? 'Easy';
    final imageUrl = _resolveImage(recipe.images);

    final nutrition = recipe.nutrition;
    final protein = nutrition?.protein ?? 0;
    final carbs = nutrition?.carbs ?? 0;
    final fat = nutrition?.fat ?? 0;

    return FeaturedRecipeCard(
      title: recipe.name ?? 'Công thức',
      calories: calories,
      duration: duration,
      difficulty: difficulty,
      imageUrl: imageUrl,
      protein: protein,
      carbs: carbs,
      fat: fat,
      isFavorite: controller.isRecipeSaved(recipe),
      isSaving: controller.isSavingRecipe(recipe),
      onTap: () {
        Get.to(() => RecipeDetailPage(recipe: recipe));
      },
      onToggleFavorite: () {
        controller.saveRecipe(recipe);
      },
    );
  }

  String _extractCalories(RecipeModel recipe) {
    if (recipe.nutrition?.calories != null) {
      return '${recipe.nutrition!.calories} kcal';
    }

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
