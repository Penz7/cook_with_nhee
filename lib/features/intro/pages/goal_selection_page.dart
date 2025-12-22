import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/features/intro/intro_controller.dart';
import 'package:cook_with_nhee/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../commons/style/colors.dart';

class GoalSelectionPage extends GetView<IntroController> {
  const GoalSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        20.height,
        Row(
          mainAxisSize: .min,
          children: [
            Assets.icons.icTarget.image(
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
            20.width,
            AppText.bold('Mục tiêu của bạn là gì?', fontSize: FontSizes.medium),
          ],
        ),
        32.height,
        Obx(
          () => Column(
            children: [
              _buildGoalOption(
                'Giảm cân',
                Icons.scale,
                controller.selectedGoal.value == 'Weight Loss',
                () => controller.selectGoal('Weight Loss'),
              ),
              16.height,
              _buildGoalOption(
                'Tăng cơ',
                Icons.fitness_center,
                controller.selectedGoal.value == 'Muscle Gain',
                () => controller.selectGoal('Muscle Gain'),
              ),
              16.height,
              _buildGoalOption(
                'Duy trì',
                Icons.check_circle_outline,
                controller.selectedGoal.value == 'Maintenance',
                () => controller.selectGoal('Maintenance'),
              ),
            ],
          ),
        ),
        30.height,
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.opacityColor(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller.customGoal,
            onChanged: (value) {
              if (value.isNotEmpty) {
                controller.selectedGoal.value = null;
              }
            },
            decoration: InputDecoration(
              hintText: 'Nhập mục tiêu tùy chỉnh...',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: FontSizes.moreSmall,
              ),
              filled: true,
              fillColor: Colors.transparent,
              prefixIcon: Icon(
                Icons.flag_outlined,
                color: UIColors.pink,
                size: 20,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalOption(
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFEC719B).opacityColor(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFEC719B) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFEC719B).opacityColor(0.2)
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? const Color(0xFFEC719B)
                    : Colors.grey.shade600,
              ),
            ),
            16.width,
            Expanded(
              child: AppText.regular(
                title,
                fontSize: FontSizes.small,
                color: const Color(0xFF3A3A3A),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFFEC719B)),
          ],
        ),
      ),
    );
  }
}
