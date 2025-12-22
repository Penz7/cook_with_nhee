import 'package:cook_with_nhee/commons/routes/route.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:cook_with_nhee/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final AuthController authController;

  RegisterController(this.authController);

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final agreeToTerms = true.obs;
  final emailValid = false.obs;
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
    // Listen to email changes
    emailController.addListener(_checkEmail);
  }

  void _checkEmail() {
    final email = emailController.text;
    emailValid.value = email.isNotEmpty && GetUtils.isEmail(email);
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleAgreeToTerms() {
    agreeToTerms.value = !agreeToTerms.value;
  }

  Future<void> handleRegister() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (!agreeToTerms.value) {
      AppToast.error('Lỗi', 'Vui lòng đồng ý với Điều khoản & Chính sách bảo mật');
      return;
    }

    try {
      isLoading.value = true;
      errorMessage = null;

      final success = await authController.register(
        emailController.text.trim(),
        passwordController.text,
        fullNameController.text.trim(),
      );

      if (success) {
        // Chuyển đến intro flow cho user mới đăng ký
        Get.offAllNamed(Routes.intro.p);
      } else {
        errorMessage = 'Đăng ký thất bại. Vui lòng thử lại.';
        AppToast.error('Lỗi đăng ký', errorMessage!);
      }
    } catch (e) {
      // Parse error message từ exception
      String message = 'Đã xảy ra lỗi. Vui lòng thử lại';
      if (e is Exception) {
        final errorStr = e.toString();
        if (errorStr.contains('Exception: ')) {
          message = errorStr.replaceFirst('Exception: ', '');
        } else if (errorStr.isNotEmpty && errorStr != 'Exception') {
          message = errorStr;
        }
      } else {
        message = e.toString();
      }
      errorMessage = message;
      AppToast.error('Lỗi đăng ký', message);
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToLogin() {
    // Sử dụng offNamed để replace route và dispose controller cũ
    Get.offNamed(Routes.login.p);
  }

  @override
  void onClose() {
    emailController.removeListener(_checkEmail);
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
