import 'package:cook_with_nhee/commons/routes/route.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:cook_with_nhee/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthController authController;

  LoginController(this.authController);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final savedEmail = await authController.getSavedEmail();
      final savedPassword = await authController.getSavedPassword();
      
      if (savedEmail != null) {
        emailController.text = savedEmail;
      }
      if (savedPassword != null) {
        passwordController.text = savedPassword;
      }
    } catch (e) {
      debugPrint('Error loading saved credentials: $e');
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> handleLogin() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage = null;

      final success = await authController.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (success) {
        Get.offAllNamed(Routes.home.p);
      } else {
        errorMessage = 'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.';
        AppToast.error('Lỗi đăng nhập', errorMessage!);
      }
    } catch (e) {
      errorMessage = 'Đã xảy ra lỗi: ${e.toString()}';
      AppToast.error('Lỗi', errorMessage!);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}