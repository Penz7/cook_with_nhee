import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text_field.dart';
import 'package:cook_with_nhee/features/intro/intro_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/assets.gen.dart';

class FoodPreferencesPage extends GetView<IntroController> {
  const FoodPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.height,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.icons.icDiet.image(
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      20.width,
                      AppText.bold(
                        'Sở thích ăn uống',
                        fontSize: FontSizes.medium,
                      ),
                    ],
                  ),
                  8.height,
                  AppText.regular(
                    'Giúp chúng tôi tạo kế hoạch bữa ăn hoàn hảo cho bạn.',
                    fontSize: FontSizes.moreSmall,
                    color: Colors.grey.shade600,
                  ),
                  32.height,
                  // Diet Type Section
                  AppText.semiBold('Loại chế độ ăn', fontSize: FontSizes.small),
                  12.height,
                  Obx(
                    () => Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: IntroController.dietTypes.map((dietType) {
                        final isSelected =
                            controller.selectedDietType.value == dietType;
                        return GestureDetector(
                          onTap: () => controller.selectDietType(dietType),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? UIColors.pink
                                  : UIColors.blue.opacityColor(0.2),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isSelected
                                    ? UIColors.pink
                                    : UIColors.blue.opacityColor(0.2),
                              ),
                            ),
                            child: AppText.regular(
                              dietType.toUpperCase(),
                              fontSize: FontSizes.moreSmall,
                              color: isSelected
                                  ? Colors.white
                                  : UIColors.textColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  32.height,
                  // Default Cuisine Section
                  AppText.semiBold(
                    'Món ăn mặc định',
                    fontSize: FontSizes.small,
                  ),
                  12.height,
                  Obx(
                    () => Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: IntroController.cuisines.map((cuisine) {
                        final isSelected =
                            controller.selectedDefaultCuisine.value == cuisine;
                        return GestureDetector(
                          onTap: () => controller.selectDefaultCuisine(cuisine),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? UIColors.pink
                                  : UIColors.blue.opacityColor(0.2),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isSelected
                                    ? UIColors.pink
                                    : UIColors.blue.opacityColor(0.2),
                              ),
                            ),
                            child: AppText.regular(
                              cuisine.toUpperCase(),
                              fontSize: FontSizes.moreSmall,
                              color: isSelected
                                  ? Colors.white
                                  : UIColors.textColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  32.height,
                  // Other Cuisines Section
                  AppText.semiBold(
                    'Other Cuisines (Optional)',
                    fontSize: FontSizes.small,
                  ),
                  8.height,
                  AppText.regular(
                    'Select additional cuisines you want to include in your plan',
                    fontSize: FontSizes.moreSmall,
                    maxLines: 2,
                  ),
                  12.height,
                  Obx(
                    () => Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: IntroController.cuisines.map((cuisine) {
                        if (controller.selectedDefaultCuisine.value ==
                            cuisine) {
                          return const SizedBox.shrink();
                        }
                        final isSelected = controller.isOtherCuisineSelected(
                          cuisine,
                        );
                        return GestureDetector(
                          onTap: () => controller.toggleOtherCuisine(cuisine),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? UIColors.pink
                                  : UIColors.blue.opacityColor(0.2),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isSelected
                                    ? UIColors.pink
                                    : UIColors.blue.opacityColor(0.2),
                              ),
                            ),
                            child: AppText.regular(
                              cuisine.toUpperCase(),
                              fontSize: FontSizes.moreSmall,
                              color: isSelected
                                  ? Colors.white
                                  : UIColors.textColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  32.height,
                  // Allergies Section
                  AppText.semiBold(
                    'Dị ứng thực phẩm (Tùy chọn)',
                    fontSize: FontSizes.small,
                  ),
                  8.height,
                  AppText.regular(
                    'Chọn các thực phẩm bạn bị dị ứng',
                    fontSize: FontSizes.small,
                  ),
                  12.height,
                  Obx(
                    () => Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: IntroController.commonAllergies.map((allergy) {
                        final isSelected = controller.isAllergySelected(
                          allergy,
                        );
                        return GestureDetector(
                          onTap: () => controller.toggleAllergy(allergy),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.red.shade300
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.red.shade400
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: AppText.regular(
                              allergy.toUpperCase(),
                              fontSize: FontSizes.moreSmall,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF3A3A3A),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  32.height,
                  // Disliked Ingredients Section
                  AppText.semiBold(
                    'Nguyên liệu không thích (Tùy chọn)',
                    fontSize: FontSizes.small,
                  ),
                  8.height,
                  AppText.regular(
                    'Nhập các nguyên liệu bạn không thích, cách nhau bằng dấu phẩy (ví dụ: nấm, khổ qua)',
                    fontSize: FontSizes.moreSmall,
                    maxLines: 2,
                  ),
                  12.height,
                  AppTextField(
                    controller: controller.dislikedIngredientsController,
                    hintText: 'mushroom, bitter-melon, ...',
                    prefixIcon: Icon(
                      Icons.restaurant_menu,
                      color: UIColors.pink,
                      size: 20,
                    ),
                    fontSize: FontSizes.moreSmall,
                    borderRadius: 20,
                    elevation: 1,
                    maxLines: 3,
                    minLines: 1,
                  ),
                  40.height, // Extra space at bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
