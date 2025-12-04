import 'package:cook_with_nhee/commons/routes/route.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../commons/extensions/number_extension.dart';
import '../../commons/widgets/app/app_image.dart';
import '../../commons/widgets/app/app_text.dart';
import '../../commons/widgets/card/app_card.dart';
import '../../commons/widgets/items/recipe_items.dart';
import '../../network/provider/api_client.dart';
import '../recipe_detail/recipe_detail_page.dart';
import '../../commons/widgets/app/app_drawer.dart';
import 'components/ingredient_selector.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(Get.find(), Get.find<ApiClient>()));
  }
}

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      drawer: AppDrawer(authController: controller.authController),
      body: Builder(
        builder: (scaffoldContext) => Obx(
          () => Stack(
            children: [
              SafeArea(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
              Obx(() {
                final currentUser = controller.authController.currentUser;
                return Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Scaffold.of(scaffoldContext).openDrawer();
                      },
                      icon: Assets.icons.icSetting.image(
                        width: 25,
                        height: 25,
                        color: UIColors.textColor,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(Routes.profile.p);
                      },
                      child: AppInternetImage(
                        url: currentUser?.avatar ?? '',
                        width: 60,
                        height: 60,
                        borderRadius: 50,
                      ),
                    ),
                  ],
                );
              }),
              20.height,
              AppCard(
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        12.width,
                        Expanded(
                          child: AppText.medium(
                            "“Chỉ cần có nguyên liệu, món ngon luôn chờ bạn sáng tạo.”",
                            fontSize: 15,
                            color: Colors.pink.shade900,
                            fontWeight: FontWeight.w600,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                    20.height,
                    AppText.semiBold(
                      "Nguyên liệu bạn đang có",
                      fontSize: 14,
                      color: Colors.pink.shade700,
                    ),
                    8.height,
                    IngredientSelector(
                      initialIngredients: const [],
                      onChange: (selected) {
                        controller.ingredients.value = selected.join(', ');
                      },
                    ),
                    20.height,
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          onPressed: controller.isLoading.value
                              ? null
                              : () async {
                                  await controller.getMagicRecipe();
                                },
                          child: controller.isLoading.value
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                    10.width,
                                    AppText.semiBold(
                                      "Đang tạo công thức...",
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.auto_awesome_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    8.width,
                                    AppText.semiBold(
                                      "Tạo công thức ngay",
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              32.height,
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.bold(
                      "Gợi ý cho bạn",
                      fontSize: 18,
                      color: Colors.pink.shade800,
                    ),
                    if (controller.recipes.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          controller.recipes.clear();
                        },
                        child: AppText.regular(
                          "Xoá kết quả",
                          fontSize: 13,
                          color: Colors.pink.shade400,
                        ),
                      ),
                  ],
                ),
              ),
              12.height,
                    Obx(() {
                      if (controller.recipes.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.menu_book_outlined,
                                size: 40,
                                color: Colors.pink.shade200,
                              ),
                              8.height,
                              AppText.regular(
                                'Chưa có công thức nào.\nHãy thêm nguyên liệu và bấm "Tạo công thức" nhé!',
                                textAlign: TextAlign.center,
                                fontSize: 14,
                                color: Colors.pink.shade400,
                                maxLines: 5,
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.recipes.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final recipe = controller.recipes[index];
                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => RecipeDetailPage(recipe: recipe),
                              );
                            },
                            child: Obx(
                              () => RecipeItems(
                                recipe: recipe,
                                showSaveButton: true,
                                isSaving: controller.isSavingRecipe(recipe),
                                isSaved: controller.isRecipeSaved(recipe),
                                onSave: () {
                                  controller.saveRecipe(recipe);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
              if (controller.isLoading.value)
                Positioned.fill(
                  child: Container(
                    color: Colors.white.withOpacity(0.85),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.pink,
                              ),
                            ),
                          ),
                          20.height,
                          AppText.semiBold(
                            "Đang tạo công thức cho bạn...",
                            fontSize: 16,
                            color: Colors.pink.shade800,
                            textAlign: TextAlign.center,
                          ),
                          8.height,
                          AppText.regular(
                            "Đang phân tích nguyên liệu bạn có...",
                            fontSize: 13,
                            color: Colors.pink.shade400,
                            textAlign: TextAlign.center,
                          ),
                          4.height,
                          AppText.regular(
                            "Kết hợp gia vị và gợi ý món ngon phù hợp.",
                            fontSize: 13,
                            color: Colors.pink.shade400,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
