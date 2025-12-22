import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/commons/widgets/items/recipe_items.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_shimmer.dart';
import 'package:cook_with_nhee/features/recipe_detail/recipe_detail_page.dart';
import 'package:cook_with_nhee/features/search_recipe/search_recipe_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/provider/api_client.dart';

class SearchRecipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => SearchRecipeController(Get.find(), Get.find<ApiClient>()),
    );
  }
}

class SearchRecipePage extends GetView<SearchRecipeController> {
  const SearchRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = [
      'Bữa ăn thường nhật',
      'Ăn sáng',
      'Ăn trưa',
      'Ăn tối',
      'Tráng miệng',
    ];
    return PrimaryScaffold(
      appBar: AppBar(
        backgroundColor: UIColors.creamy,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: AppText.bold(
          'Tìm kiếm thực đơn',
          fontSize: FontSizes.medium,
          color: Colors.black87,
        ),
        centerTitle: true,
      ),
      backgroundColor: const BoxDecoration(color: UIColors.creamy),
      body: Obx(() {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.opacityColor(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: controller.searchTextController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) =>
                            controller.searchRecipes(value.trim()),
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm thực đơn yêu thích....',
                          hintStyle: TextStyle(
                            fontSize: FontSizes.moreSmall,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                  ),
                  10.width,
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        UIColors.pink.opacityColor(0.5),
                      ),
                    ),
                    onPressed: () =>
                        controller.searchRecipes(
                          controller.searchTextController.text.trim(),
                        ),
                    icon: const Icon(Icons.search, color: Colors.white),
                  ),
                ],
              ),
            ),
            Obx(() {
              final currentQuery =
                  controller.searchQuery.value.trim().toLowerCase();
              return SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: tags.length,
                  separatorBuilder: (_, _) => 10.width,
                  itemBuilder: (context, index) {
                    final tag = tags[index];
                    final normalizedTag = tag.trim().toLowerCase();
                    final isSelected = currentQuery == normalizedTag;
                    return ChoiceChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (_) {
                        controller.searchQuery.value = tag;
                        controller.searchTextController.text = tag;
                        controller.searchTextController.selection =
                            TextSelection.collapsed(offset: tag.length);
                        controller.searchRecipes(tag);
                      },
                      selectedColor: UIColors.pinkLight,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : UIColors.textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
              );
            }),
            12.height,
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: AppRecipeListShimmer(itemCount: 6),
                  );
                }

                if (controller.recipes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        20.height,
                        AppText.regular(
                          controller.searchQuery.value.isEmpty
                              ? 'Nhập từ khóa để tìm kiếm công thức'
                              : 'Không tìm thấy công thức nào\nvới "${controller.searchQuery.value}"',
                          textAlign: TextAlign.center,
                          fontSize: FontSizes.moreSmall,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.recipes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final recipe = controller.recipes[index];
                    return InkWell(
                      onTap: () {
                        Get.to(() => RecipeDetailPage(recipe: recipe));
                      },
                      child: RecipeItems(
                        recipe: recipe,
                        showSaveButton: true,
                        onSave: () => controller.saveRecipe(recipe),
                        isSaving: controller.isSavingRecipe(recipe),
                        isSaved: controller.isRecipeSaved(recipe),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
