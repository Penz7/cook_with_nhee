import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BMICalculatorController extends GetxController {
  // Unit selection: true = Metric (cm/kg), false = Imperial (ft+in/lbs)
  final RxBool isMetric = true.obs;

  // Metric values
  final RxDouble heightCm = 175.0.obs;
  final RxDouble weightKg = 68.0.obs;

  // Imperial values
  final RxInt heightFeet = 5.obs;
  final RxInt heightInches = 9.obs;
  final RxDouble weightLbs = 150.0.obs;

  // Weight history (sample data)
  final RxList<WeightHistoryPoint> weightHistory = <WeightHistoryPoint>[
    WeightHistoryPoint(date: DateTime(2024, 10, 1), weight: 70.0),
    WeightHistoryPoint(date: DateTime(2024, 10, 8), weight: 69.5),
    WeightHistoryPoint(date: DateTime(2024, 10, 15), weight: 69.0),
    WeightHistoryPoint(date: DateTime(2024, 10, 22), weight: 68.5),
    WeightHistoryPoint(date: DateTime.now(), weight: 68.0),
  ].obs;

  // Calculate BMI
  double get bmi {
    if (isMetric.value) {
      final heightM = heightCm.value / 100;
      return weightKg.value / (heightM * heightM);
    } else {
      final heightInchesTotal = (heightFeet.value * 12) + heightInches.value;
      final heightM = heightInchesTotal * 0.0254;
      final weightKg = weightLbs.value * 0.453592;
      return weightKg / (heightM * heightM);
    }
  }

  // Get BMI category
  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue < 18.5) {
      return 'Thiếu cân';
    } else if (bmiValue < 25) {
      return 'Cân nặng bình thường';
    } else if (bmiValue < 30) {
      return 'Thừa cân';
    } else {
      return 'Béo phì';
    }
  }

  // Get BMI category description
  String get bmiDescription {
    final category = bmiCategory;
    switch (category) {
      case 'Thiếu cân':
        return 'Hãy cân nhắc tham khảo ý kiến bác sĩ.';
      case 'Cân nặng bình thường':
        return 'Bạn đang làm rất tốt! Hãy tiếp tục phát huy.';
      case 'Thừa cân':
        return 'Hãy cân nhắc chế độ ăn cân bằng và tập thể dục thường xuyên.';
      case 'Béo phì':
        return 'Vui lòng tham khảo ý kiến bác sĩ.';
      default:
        return 'Bạn đang làm rất tốt! Hãy tiếp tục phát huy.';
    }
  }

  // Get BMI color
  Color get bmiColor {
    final bmiValue = bmi;
    if (bmiValue < 18.5) {
      return Colors.blue;
    } else if (bmiValue < 25) {
      return Colors.green;
    } else if (bmiValue < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // Get current weight in kg (for display)
  double get currentWeightKg {
    if (isMetric.value) {
      return weightKg.value;
    } else {
      return weightLbs.value * 0.453592;
    }
  }

  // Get weight change
  double get weightChange {
    if (weightHistory.isEmpty) return 0;
    final firstWeight = weightHistory.first.weight;
    final lastWeight = weightHistory.last.weight;
    return lastWeight - firstWeight;
  }

  // Update height (Metric)
  void updateHeightCm(double value) {
    heightCm.value = value.roundToDouble();
  }

  // Update weight (Metric)
  void updateWeightKg(double value) {
    weightKg.value = value.roundToDouble();
  }

  // Update height (Imperial)
  void updateHeightFeet(int value) {
    heightFeet.value = value;
  }

  void updateHeightInches(int value) {
    heightInches.value = value;
  }

  // Update weight (Imperial)
  void updateWeightLbs(double value) {
    weightLbs.value = value.roundToDouble();
  }

  // Toggle unit
  void toggleUnit(bool isMetricValue) {
    isMetric.value = isMetricValue;
  }

  // Save to history
  void saveToHistory() {
    final newPoint = WeightHistoryPoint(
      date: DateTime.now(),
      weight: currentWeightKg,
    );
    weightHistory.add(newPoint);
    
    // Keep only last 30 days of history
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    weightHistory.removeWhere((point) => point.date.isBefore(thirtyDaysAgo));
    
    Get.snackbar(
      'Đã lưu',
      'Cân nặng đã được lưu vào lịch sử thành công.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
    );
  }

  // Show info dialog
  void showInfo() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Máy tính BMI',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: const Text(
          'Chỉ số khối cơ thể (BMI) là thước đo lượng mỡ cơ thể dựa trên chiều cao và cân nặng. '
          'Nó cung cấp một chỉ số chung về việc cân nặng của bạn có khỏe mạnh so với chiều cao hay không.\n\n'
          'Phân loại BMI:\n'
          '• Thiếu cân: Dưới 18.5\n'
          '• Cân nặng bình thường: 18.5 - 24.9\n'
          '• Thừa cân: 25 - 29.9\n'
          '• Béo phì: 30 trở lên',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Đã hiểu'),
          ),
        ],
      ),
    );
  }
}

class WeightHistoryPoint {
  WeightHistoryPoint({
    required this.date,
    required this.weight,
  });

  final DateTime date;
  final double weight;
}

