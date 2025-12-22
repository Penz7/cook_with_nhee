import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/context_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_image.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../network/models/recipe_model.dart';
import 'components/chip_info_summary.dart';
import 'components/chip_target_audience.dart';
import 'components/ingredient_item.dart';
import 'components/nutrition_bar.dart';

class RecipeDetailPage extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  String _extractImageUrl() {
    final images = recipe.images;
    if (images != null && images.isNotEmpty) {
      final first = images.first;
      if (first is String) {
        return first;
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _extractImageUrl();
    final nutrition = recipe.nutrition;
    final prepTime = recipe.prepTime ?? recipe.cookingTime ?? '';
    final difficulty = recipe.difficulty ?? 'Dễ';

    return PrimaryScaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  _buildRecipeImage(context, imageUrl),
                  Positioned(child: _buildHeader(context)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: UIColors.creamy,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    20.height,
                    _buildInfoCard(context, prepTime, difficulty, nutrition),
                    30.height,
                    if (nutrition != null)
                      _buildNutritionSection(context, nutrition),
                    30.height,
                    if (recipe.ingredients != null &&
                        recipe.ingredients!.isNotEmpty)
                      _buildIngredientsSection(context),
                    30.height,
                    if (recipe.steps != null && recipe.steps!.isNotEmpty)
                      _buildDirectionsSection(context),
                    30.height,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.transparent,
      child: Row(
        children: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.opacityColor(0.4),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            onPressed: () => Get.back(),
          ),
          const Spacer(),
          Obx(() {
            final authController = Get.find<AuthController>();
            final isSaving = authController.isSavingRecipe(recipe);
            final isSaved = authController.isRecipeSaved(recipe);

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: isSaving
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              UIColors.pink,
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSaved
                                ? UIColors.pinkLight
                                : Colors.grey.opacityColor(0.4),
                          ),
                          child: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            color: isSaved ? UIColors.pink : Colors.white,
                          ),
                        ),
                  onPressed: (isSaving || isSaved)
                      ? null
                      : () => authController.saveRecipe(recipe),
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.opacityColor(0.4),
                    ),
                    child: const Icon(
                      Icons.share_outlined,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    // TODO: Implement share functionality
                  },
                ),
              ],
            );
          }),
        ],
      ),
    );
  }


  Widget _buildRecipeImage(BuildContext context, String imageUrl) {
    return SizedBox(
      height: context.screenHeight * 1 / 4,
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: AppInternetImage(
          url: imageUrl,
          fit: BoxFit.contain,
          isFood: true,
          isBlur: true,
          enablePreview: true,
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String prepTime,
    String difficulty,
    Nutrition? nutrition,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bold(
          recipe.name ?? 'Công thức',
          fontSize: FontSizes.medium,
          maxLines: 2,
        ),
        16.height,
        if (recipe.targetAudience != null && recipe.targetAudience!.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recipe.targetAudience!.take(2).map((tag) {
              return ChipTargetAudience(label: tag);
            }).toList(),
          ),
        10.height,
        if (recipe.tags != null && recipe.tags!.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recipe.tags!.take(2).map((tag) {
              return ChipTargetAudience(label: tag.name ?? '');
            }).toList(),
          ),
        24.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ChipInfoSummary(
              icon: Icons.local_fire_department,
              value: nutrition?.calories?.toString() ?? '0',
              label: 'Calo',
              iconColor: UIColors.pink,
            ),
            ChipInfoSummary(
              icon: Icons.timer_outlined,
              value: prepTime,
              label: 'Thời gian chuẩn bị',
              iconColor: UIColors.blue,
            ),
            ChipInfoSummary(
              icon: Icons.bar_chart,
              value: difficulty,
              label: 'Độ khó',
              iconColor: UIColors.purple,
            ),
          ],
        ),
        24.height,
        if (recipe.description != null && recipe.description!.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: UIColors.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.opacityColor(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AppText.medium(
              recipe.description ?? '',
              fontSize: FontSizes.moreSmall,
              color: Colors.black,
              maxLines: 10,
            ),
          ),
      ],
    );
  }

  Widget _buildNutritionSection(BuildContext context, Nutrition nutrition) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bold('Dinh dưỡng mỗi phần', fontSize: FontSizes.medium),
        16.height,
        NutritionBar(
          label: 'Protein',
          value: nutrition.protein ?? 0,
          maxValue: 100,
        ),
        12.height,
        NutritionBar(label: 'Carb', value: nutrition.carbs ?? 0, maxValue: 100),
        12.height,
        NutritionBar(
          label: 'Chất béo',
          value: nutrition.fat ?? 0,
          maxValue: 100,
        ),
      ],
    );
  }

  Widget _buildIngredientsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bold('Nguyên liệu', fontSize: FontSizes.medium),
        16.height,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2,
          ),
          itemCount: recipe.ingredients!.length,
          itemBuilder: (context, index) {
            final ing = recipe.ingredients![index];
            return IngredientItem(
              name: ing.name ?? '',
              description: ing.quantity ?? '',
            );
          },
        ),
      ],
    );
  }

  Widget _buildDirectionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bold('Hướng dẫn', fontSize: FontSizes.medium),
        20.height,
        ...recipe.steps!.asMap().entries.map((entry) {
          final isLast = entry.key == recipe.steps!.length - 1;
          return _DirectionStep(
            stepNumber: entry.key + 1,
            text: entry.value,
            isLast: isLast,
          );
        }),
      ],
    );
  }
}

class _DirectionStep extends StatelessWidget {
  final int stepNumber;
  final String text;
  final bool isLast;

  const _DirectionStep({
    required this.stepNumber,
    required this.text,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: UIColors.blue.opacityColor(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppText.bold(
                  '$stepNumber',
                  fontSize: 14,
                  color: UIColors.blue,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: UIColors.blue.opacityColor(0.3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
        16.width,
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: AppText.regular(
              text,
              fontSize: FontSizes.small,
              maxLines: 5,
            ),
          ),
        ),
      ],
    );
  }
}
