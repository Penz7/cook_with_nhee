import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text_field.dart';
import 'package:cook_with_nhee/features/intro/intro_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../commons/style/colors.dart';
import '../../../commons/style/font_sizes.dart';
import '../../../generated/assets.gen.dart';

class BodyStatsPage extends GetView<IntroController> {
  const BodyStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Content
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
                        Assets.icons.icBodyMeasurement.image(
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                        20.width,
                        AppText.bold(
                          'Chỉ số cơ thể của bạn',
                          fontSize: FontSizes.medium,
                        ),
                      ],
                    ),
                    32.height,
                    // Height
                    AppText.regular(
                      'Chiều cao',
                      fontSize: 14,
                      color: const Color(0xFF3A3A3A),
                    ),
                    8.height,
                    Obx(
                      () => AppTextField(
                        controller: controller.heightController,
                        keyboardType: TextInputType.number,
                        hintText: 'cm',
                        prefixIcon: Icon(
                          Icons.height,
                          color: UIColors.pink,
                          size: 20,
                        ),
                        errorText: controller.heightError.value,
                        fontSize: FontSizes.moreSmall,
                        elevation: 2,
                      ),
                    ),
                    20.height,
                    // Weight
                    AppText.regular(
                      'Cân nặng',
                      fontSize: 14,
                      color: const Color(0xFF3A3A3A),
                    ),
                    8.height,
                    Obx(
                      () => AppTextField(
                        controller: controller.weightController,
                        keyboardType: TextInputType.number,
                        hintText: 'kg',
                        prefixIcon: Icon(
                          Icons.monitor_weight,
                          color: UIColors.pink,
                          size: 20,
                        ),
                        errorText: controller.weightError.value,
                        fontSize: FontSizes.moreSmall,
                        elevation: 2,
                      ),
                    ),
                    20.height,
                    // Chest size
                    AppText.regular(
                      'Vòng ngực',
                      fontSize: 14,
                      color: const Color(0xFF3A3A3A),
                    ),
                    8.height,
                    Obx(
                      () => AppTextField(
                        controller: controller.chestController,
                        keyboardType: TextInputType.number,
                        hintText: 'cm',
                        prefixIcon: Icon(
                          Icons.accessibility_new,
                          color: UIColors.pink,
                          size: 20,
                        ),
                        errorText: controller.chestError.value,
                        fontSize: FontSizes.moreSmall,
                        elevation: 2,
                      ),
                    ),
                    20.height,
                    // Waist size
                    AppText.regular(
                      'Waist size',
                      fontSize: 14,
                      color: const Color(0xFF3A3A3A),
                    ),
                    8.height,
                    Obx(
                      () => AppTextField(
                        controller: controller.waistController,
                        keyboardType: TextInputType.number,
                        hintText: 'cm',
                        prefixIcon: Icon(
                          Icons.straighten,
                          color: UIColors.pink,
                          size: 20,
                        ),
                        errorText: controller.waistError.value,
                        fontSize: FontSizes.moreSmall,
                        elevation: 2,
                      ),
                    ),
                    20.height,
                    // Hip size
                    AppText.regular(
                      'Vòng mông',
                      fontSize: 14,
                      color: const Color(0xFF3A3A3A),
                    ),
                    8.height,
                    Obx(
                      () => AppTextField(
                        controller: controller.hipController,
                        keyboardType: TextInputType.number,
                        hintText: 'cm',
                        prefixIcon: Icon(
                          Icons.accessibility,
                          color: UIColors.pink,
                          size: 20,
                        ),
                        errorText: controller.hipError.value,
                        fontSize: FontSizes.moreSmall,
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
            ),
          ),
        ],
      ),
    );
  }
}
