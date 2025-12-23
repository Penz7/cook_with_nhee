import 'package:cook_with_nhee/features/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../commons/extensions/color_extension.dart';
import '../../../commons/extensions/number_extension.dart';
import '../../../commons/style/font_sizes.dart';
import '../../../commons/widgets/app/app_image.dart';
import '../../../commons/widgets/app/app_shimmer.dart';
import '../../../commons/widgets/app/app_text.dart';
import '../../../network/models/recipe_model.dart';
import '../../recipe_detail/recipe_detail_page.dart';

class RecommendationRecipes extends GetView<HomeController> {
  const RecommendationRecipes({super.key});

  static const List<LinearGradient> _gradients = [
    LinearGradient(
      colors: [Color(0xFFFFC6A8), Color(0xFFFF9A7A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFFAD9E), Color(0xFFFF8B86)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFB8E6B8), Color(0xFF90D490)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFB8D4E6), Color(0xFF90B8D4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFE6B8E6), Color(0xFFD490D4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

  LinearGradient _getGradient(int index) {
    return _gradients[index % _gradients.length];
  }

  _RecommendationItem _mapRecipeToItem(RecipeModel recipe, int index) {
    String tag = '';
    if (recipe.tags != null && recipe.tags!.isNotEmpty) {
      tag = recipe.tags!.first.name ?? '';
    } else if (recipe.targetAudience != null &&
        recipe.targetAudience!.isNotEmpty) {
      tag = recipe.targetAudience!.first;
    }

    String calories = '';
    if (recipe.nutrition != null && recipe.nutrition!.calories != null) {
      calories = '${recipe.nutrition!.calories} kcal';
    }

    // Get duration from cookingTime or cookTime
    String duration = recipe.cookingTime ?? recipe.cookTime ?? '';

    // Build subtitle from tags or description
    String subtitle = '';
    if (recipe.tags != null && recipe.tags!.isNotEmpty) {
      final tagNames = recipe.tags!
          .take(2)
          .map((t) => t.name ?? '')
          .where((n) => n.isNotEmpty)
          .toList();
      subtitle = tagNames.join(' • ');
    }
    if (subtitle.isEmpty && recipe.description != null) {
      subtitle = recipe.description!.length > 30
          ? '${recipe.description!.substring(0, 30)}...'
          : recipe.description!;
    }
    if (subtitle.isEmpty) {
      subtitle = 'Công thức ngon';
    }

    return _RecommendationItem(
      title: recipe.name ?? 'Công thức',
      subtitle: subtitle,
      calories: calories,
      duration: duration,
      tag: tag.isNotEmpty ? tag : 'Công thức',
      gradient: _getGradient(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final recipes = controller.recommendationRecipes;
      final isLoading = controller.isLoadingRecommendations.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                AppText.bold('Đề xuất', fontSize: FontSizes.medium),
                // const Spacer(),
                // TextButton(
                //   onPressed: () {},
                //   child: AppText.bold(
                //     'Tùy chỉnh',
                //     fontSize: FontSizes.extraSmall,
                //     color: UIColors.pink,
                //   ),
                // ),
              ],
            ),
          ),
          15.height,
          SizedBox(
            height: 240,
            child: isLoading
                ? const AppRecommendationShimmer()
                : recipes.isEmpty
                ? Center(
                    child: AppText.medium(
                      'Không có công thức đề xuất',
                      fontSize: FontSizes.moreSmall,
                      color: Colors.grey.shade600,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: recipes.length,
                    separatorBuilder: (_, _) => 12.width,
                    itemBuilder: (_, index) {
                      final recipe = recipes[index];
                      final item = _mapRecipeToItem(recipe, index);
                      return InkWell(
                        onTap: () {
                          Get.to(() => RecipeDetailPage(recipe: recipe));
                        },
                        child: _RecommendationCard(item: item, recipe: recipe),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}

class _RecommendationItem {
  const _RecommendationItem({
    required this.title,
    required this.subtitle,
    required this.calories,
    required this.duration,
    required this.tag,
    required this.gradient,
  });

  final String title;
  final String subtitle;
  final String calories;
  final String duration;
  final String tag;
  final Gradient gradient;
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.item, required this.recipe});

  final _RecommendationItem item;
  final RecipeModel recipe;

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

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.opacityColor(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: SizedBox(
              height: 130,
              width: double.infinity,
              child: Stack(
                children: [
                  AppInternetImage(
                    url: imageUrl,
                    width: double.infinity,
                    height: 130,
                    fit: BoxFit.cover,
                    isFood: true,
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.opacityColor(0.9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: AppText.bold(
                        item.tag,
                        fontSize: FontSizes.extraSmall,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.opacityColor(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.grey.shade700,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.bold(
                  item.title,
                  fontSize: FontSizes.moreSmall,
                  color: Colors.black87,
                ),
                6.height,
                AppText.medium(
                  item.subtitle,
                  fontSize: FontSizes.extraSmall,
                  color: Colors.grey.shade600,
                  maxLines: 1,
                ),
                12.height,
                Row(
                  children: [
                    Icon(Icons.bolt, size: 20, color: Colors.pink.shade400),
                    4.width,
                    AppText.bold(
                      item.calories,
                      fontSize: FontSizes.extraSmall,
                      color: Colors.pink.shade700,
                    ),
                    10.width,
                    Icon(Icons.schedule, size: 20, color: Colors.grey.shade500),
                    4.width,
                    Expanded(
                      child: AppText.medium(
                        item.duration,
                        fontSize: FontSizes.extraSmall,
                        color: Colors.grey.shade700,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
