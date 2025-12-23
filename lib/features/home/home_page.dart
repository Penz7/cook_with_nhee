import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/routes/route.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_image.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/features/home/components/recommendation_recipes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/provider/api_client.dart';
import 'components/recipe_of_the_day_card.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(Get.find(), Get.find<ApiClient>()));
  }
}

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  String _greetingMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return 'Chào buổi sáng,';
    if (hour >= 11 && hour < 13) return 'Chào buổi trưa,';
    if (hour >= 13 && hour < 18) return 'Chào buổi chiều,';
    return 'Chào buổi tối,';
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      backgroundColor: const BoxDecoration(color: UIColors.creamy),
      body: Obx(() {
        final greeting = _greetingMessage();
        final currentUser = controller.authController.currentUser;
        final userName = currentUser?.name ?? 'Người dùng';
        final userAvatar = currentUser?.avatar ?? '';
        return RefreshIndicator(
          onRefresh: controller.refreshHomeData,
          color: UIColors.pink,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            AppInternetImage(
                              url: userAvatar,
                              width: 50,
                              height: 50,
                              borderRadius: 25,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        12.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.regular(
                                greeting,
                                fontSize: FontSizes.moreSmall,
                              ),
                              2.height,
                              AppText.bold(
                                userName,
                                fontSize: FontSizes.medium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.searchRecipe.p);
                    },
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
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
                          Expanded(
                            child: DefaultTextStyle(
                              style: TextStyle(
                                fontSize: FontSizes.small,
                                color: UIColors.textColor.opacityColor(0.8),
                              ),
                              child: AnimatedTextKit(
                                pause: const Duration(seconds: 1),
                                repeatForever: true,
                                onTap: () {
                                  Get.toNamed(Routes.searchRecipe.p);
                                },
                                animatedTexts: [
                                  RotateAnimatedText(
                                    '🥗 Tìm món ăn healthy, giảm cân',
                                    transitionHeight: 40,
                                    duration: const Duration(
                                      seconds: 3,
                                    ),
                                  ),
                                  RotateAnimatedText(
                                    '🍜 Món Thái Lan, Nhật Bản, Châu Âu...',
                                    transitionHeight: 40,
                                    duration: const Duration(seconds: 3),
                                  ),
                                  RotateAnimatedText(
                                    '🍳 Đồ ăn sáng tăng cân, tăng cơ',
                                    transitionHeight: 40,
                                    duration: const Duration(seconds: 3),
                                  ),
                                  RotateAnimatedText(
                                    '🌱 Món chay, ăn kiêng, detox',
                                    transitionHeight: 40,
                                    duration: const Duration(seconds: 3),
                                  ),
                                  RotateAnimatedText(
                                    '🧁 Bánh ngọt, dessert, kem',
                                    transitionHeight: 40,
                                    duration: const Duration(seconds: 3),
                                  ),
                                  RotateAnimatedText(
                                    '🔥 Món nướng, BBQ, lẩu',
                                    transitionHeight: 40,
                                    duration: const Duration(seconds: 3),
                                  ),
                                  RotateAnimatedText(
                                    '🥤 Salad, smoothie, nước ép',
                                    transitionHeight: 40,
                                    duration: const Duration(seconds: 3),
                                  ),
                                  RotateAnimatedText(
                                    '🇻🇳 Món Việt Nam truyền thống',
                                    transitionHeight: 40,
                                    duration: const Duration(seconds: 3),
                                  ),
                                  RotateAnimatedText(
                                    '🍿 Đồ ăn vặt, snack, finger food',
                                    transitionHeight: 40,
                                    duration: const Duration(seconds: 3),
                                  ),
                                  RotateAnimatedText(
                                    '👶 Món cho bé, dinh dưỡng',
                                    transitionHeight: 40,
                                    duration: const Duration(seconds: 3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: 30.height),
              SliverToBoxAdapter(
                child: Obx(() {
                  if (!controller.isInitialDataLoaded) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppText.bold(
                                'Công thức trong ngày',
                                fontSize: FontSizes.medium,
                              ),
                            ],
                          ),
                        ),
                        const RecipeOfTheDayCard(),
                        20.height,
                        const RecommendationRecipes(),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppText.bold(
                              'Công thức trong ngày',
                              fontSize: FontSizes.medium,
                            ),
                          ],
                        ),
                      ),
                      const RecipeOfTheDayCard(),
                      20.height,
                      const RecommendationRecipes(),
                    ],
                  );
                }),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: const _CreateWithAISection(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      }),
    );
  }
}

class _CreateWithAISection extends StatelessWidget {
  const _CreateWithAISection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1F1A2E), Color(0xFF2C1F3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.opacityColor(0.20),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.bold(
                  'Tạo với AI',
                  fontSize: FontSizes.moreSmall,
                  color: Colors.white,
                ),
                8.height,
                AppText.medium(
                  'Tạo kế hoạch bữa ăn tùy chỉnh dựa trên nguyên liệu của bạn.',
                  fontSize: FontSizes.extraSmall,
                  color: Colors.white.opacityColor(0.8),
                  maxLines: 2,
                ),
                14.height,
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.createRecipe.p);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText.bold(
                          'Thử Generator',
                          fontSize: FontSizes.extraSmall,
                          color: Colors.black87,
                        ),
                        8.width,
                        const Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          12.width,
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [UIColors.pink, UIColors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.opacityColor(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
