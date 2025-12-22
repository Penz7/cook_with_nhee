import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/context_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_image.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_shimmer.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/network/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home_controller.dart';
import '../../recipe_detail/recipe_detail_page.dart';

class RecipeOfTheDayCard extends GetView<HomeController> {
  const RecipeOfTheDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingRecipeOfDay.value) {
        return const AppRecipeOfDayShimmer();
      }

      final RecipeModel? recipe = controller.recipeOfDay.value;
      if (recipe == null) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.opacityColor(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.menu_book_outlined, color: Colors.grey),
                12.width,
                Expanded(
                  child: AppText.medium(
                    'Công thức trong ngày hiện chưa có dữ liệu.',
                    fontSize: FontSizes.small,
                    color: Colors.grey.shade700,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final String imageUrl = _extractImageUrl(recipe);
      final String title = recipe.name ?? 'Công thức trong ngày';
      final String? cookingTime = recipe.cookingTime ?? recipe.cookTime;
      final String? difficulty = recipe.difficulty;
      final int? calories = recipe.nutrition?.calories;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.opacityColor(0.05),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            SizedBox(
              width: context.screenWidth,
              height: context.screenHeight * 1 / 2,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 11,
                      child: AppInternetImage(
                        url: imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        isBlur: true,
                        isFood: true,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.opacityColor(0.55),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (calories != null)
              Positioned(
                top: 12,
                right: 12,
                child: _infoChip(Icons.local_fire_department, '$calories kcal'),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 10,
                  bottom: 25,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppText.bold(
                            title,
                            fontSize: FontSizes.small,
                            maxLines: 2,
                          ),
                        ),
                        10.width,
                        Obx(() {
                          final isSaving = controller.isSavingRecipe(recipe);
                          final isSaved = controller.isRecipeSaved(recipe);

                          return IconButton(
                            onPressed: (isSaving || isSaved)
                                ? null
                                : () => controller.saveRecipe(recipe),
                            icon: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: UIColors.backgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.opacityColor(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: isSaving
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              UIColors.pink,
                                            ),
                                      ),
                                    )
                                  : Icon(
                                      isSaved
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: UIColors.pink,
                                      size: 20,
                                    ),
                            ),
                          );
                        }),
                      ],
                    ),
                    if (difficulty != null && difficulty.isNotEmpty)
                      AppText.regular(
                        difficulty,
                        fontSize: FontSizes.moreSmall,
                        color: Colors.grey,
                      ),
                    10.height,
                    if ((recipe.ingredients ?? []).isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.schedule, color: UIColors.pink, size: 20),
                          10.width,
                          Expanded(
                            child: AppText.bold(
                              '$cookingTime',
                              fontSize: FontSizes.extraSmall,
                            ),
                          ),
                          20.width,
                          Icon(
                            Icons.restaurant,
                            color: UIColors.blue,
                            size: 20,
                          ),
                          10.width,
                          AppText.bold(
                            '${recipe.ingredients?.length} nguyên liệu',
                            fontSize: FontSizes.extraSmall,
                          ),
                        ],
                      ),
                    20.height,
                    InkWell(
                      onTap: () {
                        Get.to(() => RecipeDetailPage(recipe: recipe));
                      },
                      child: Container(
                        width: context.screenWidth,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [UIColors.pink, UIColors.pinkLight],
                            begin: AlignmentGeometry.topLeft,
                            end: AlignmentGeometry.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.opacityColor(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: .min,
                          mainAxisAlignment: .center,
                          children: [
                            AppText.bold(
                              'Xem công thức',
                              fontSize: FontSizes.small,
                              color: Colors.white,
                            ),
                            10.width,
                            Icon(
                              Icons.arrow_forward_sharp,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  String _extractImageUrl(RecipeModel recipe) {
    final images = recipe.images;
    if (images != null && images.isNotEmpty) {
      final first = images.first;
      if (first is String) {
        return first;
      }
    }
    return '';
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFF7F1FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Color(0xFF4A148C)),
          6.width,
          AppText.bold(
            label,
            fontSize: FontSizes.extraSmall,
            color: Color(0xFF4A148C),
          ),
        ],
      ),
    );
  }
}
