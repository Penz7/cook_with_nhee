import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/features/bmi_calculator/components/bmi_display_card.dart';
import 'package:cook_with_nhee/features/bmi_calculator/components/measurement_slider_card.dart';
import 'package:cook_with_nhee/features/bmi_calculator/components/weight_history_card.dart';
import 'package:cook_with_nhee/features/bmi_calculator/bmi_calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../commons/extensions/color_extension.dart';

class BMICalculatorPage extends GetView<BMICalculatorController> {
  const BMICalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      backgroundColor: const BoxDecoration(color: UIColors.creamy),
      appBar: AppBar(
        backgroundColor: UIColors.creamy,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.opacityColor(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
          ),
          onPressed: () => Get.back(),
        ),
        title: AppText.bold(
          'Máy tính BMI',
          fontSize: 20,
          color: Colors.black87,
          fontWeight: FontWeight.w800,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.info, color: Colors.white, size: 18),
            ),
            onPressed: controller.showInfo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Unit Selector
            Obx(() => Container(
                  padding: const EdgeInsets.all(4),
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
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.toggleUnit(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: controller.isMetric.value
                                  ? UIColors.pink
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Text(
                              'Hệ mét',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: controller.isMetric.value
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.toggleUnit(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !controller.isMetric.value
                                  ? UIColors.pink
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Text(
                              'Hệ Anh',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: !controller.isMetric.value
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            24.height,
            // BMI Display Card
            Obx(() => BMIDisplayCard(
                  bmiValue: controller.bmi,
                  category: controller.bmiCategory,
                  description: controller.bmiDescription,
                  color: controller.bmiColor,
                )),
            24.height,
            // Height Slider
            Obx(() => controller.isMetric.value
                ? MeasurementSliderCard(
                    icon: Icons.height,
                    label: 'Chiều cao',
                    value: controller.heightCm.value,
                    unit: 'cm',
                    min: 100,
                    max: 250,
                    onChanged: controller.updateHeightCm,
                  )
                : MeasurementSliderCard(
                    icon: Icons.height,
                    label: 'Chiều cao',
                    value: controller.heightInches.value.toDouble(),
                    unit: 'in',
                    min: 0,
                    max: 11,
                    isImperial: true,
                    secondaryValue: controller.heightFeet.value,
                    secondaryUnit: 'ft',
                    onChanged: (value) {
                      final double = value.toInt();
                      controller.updateHeightInches(double);
                    },
                    onSecondaryChanged: controller.updateHeightFeet,
                  )),
            16.height,
            // Weight Slider
            Obx(() => controller.isMetric.value
                ? MeasurementSliderCard(
                    icon: Icons.monitor_weight,
                    label: 'Cân nặng',
                    value: controller.weightKg.value,
                    unit: 'kg',
                    min: 30,
                    max: 200,
                    onChanged: controller.updateWeightKg,
                  )
                : MeasurementSliderCard(
                    icon: Icons.monitor_weight,
                    label: 'Cân nặng',
                    value: controller.weightLbs.value,
                    unit: 'lbs',
                    min: 66,
                    max: 440,
                    onChanged: controller.updateWeightLbs,
                  )),
            24.height,
            // Weight History Card
            Obx(() => WeightHistoryCard(
                  history: controller.weightHistory,
                  weightChange: controller.weightChange,
                )),
            24.height,
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.saveToHistory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save, size: 20),
                    8.width,
                    const Text(
                      'Lưu vào lịch sử',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            40.height,
          ],
        ),
      ),
    );
  }
}

