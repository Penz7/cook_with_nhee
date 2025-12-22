import 'package:cook_with_nhee/commons/routes/route.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:cook_with_nhee/controller/auth_controller.dart';
import 'package:cook_with_nhee/network/provider/api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthController authController;
  final ApiClient apiClient;

  LoginController(this.authController, this.apiClient);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final rememberMe = true.obs;
  final emailValid = false.obs;
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
    // Listen to email changes
    emailController.addListener(_checkEmail);
  }

  void _checkEmail() {
    final email = emailController.text;
    emailValid.value = email.isNotEmpty && GetUtils.isEmail(email);
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

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
    authController.toggleRememberMe();
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
        // Lưu remember me setting
        if (rememberMe.value) {
          await authController.saveCredentials(
            emailController.text.trim(),
            passwordController.text,
          );
        }
        // Sau khi login thành công, kiểm tra measurements
        await _checkMeasurementsAndNavigate();
      } else {
        errorMessage = 'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.';
        AppToast.error('Lỗi đăng nhập', errorMessage!);
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
      AppToast.error('Lỗi đăng nhập', message);
    } finally {
      isLoading.value = false;
    }
  }

  /// Kiểm tra measurements sau khi login thành công
  Future<void> _checkMeasurementsAndNavigate() async {
    try {
      final measurementsResponse = await apiClient.getMeasurements();
      if (measurementsResponse.status == 200) {
        final measurements = measurementsResponse.data;
        final isEmpty = measurements == null;
        
        if (isEmpty) {
          debugPrint("[LOGIN] Measurements rỗng, chuyển đến intro");
          Get.offAllNamed(Routes.intro.p);
        } else {
          debugPrint("[LOGIN] Người dùng đã có measurements, chuyển đến home");
          Get.offAllNamed(Routes.home.p);
        }
      } else {
        debugPrint("[LOGIN] Không thể lấy measurements, chuyển đến intro");
        Get.offAllNamed(Routes.intro.p);
      }
    } catch (e) {
      debugPrint("[LOGIN] Lỗi khi gọi API measurements: $e");
      debugPrint("[LOGIN] Chuyển đến intro để người dùng có thể thiết lập");
      Get.offAllNamed(Routes.intro.p);
    }
  }

  void navigateToRegister() {
    Get.offNamed(Routes.register.p);
  }

  @override
  void onClose() {
    emailController.removeListener(_checkEmail);
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}