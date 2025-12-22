import 'package:get/get.dart';
import 'bmi_calculator_controller.dart';

class BMICalculatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BMICalculatorController());
  }
}

