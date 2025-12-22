import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/controller/auth_controller.dart';
import 'package:cook_with_nhee/features/authentication/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../commons/extensions/number_extension.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => LoginController(Get.find<AuthController>(), Get.find()),
      fenix: true,
    );
  }
}

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: UIColors.pinkLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: UIColors.textColor,
                    ),
                    onPressed: () => Get.back(),
                  ),
                  Padding(
                    padding: const EdgeInsetsGeometry.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        16.height,
                        AppText.bold('Chào mừng trở lại', color: UIColors.textColor),
                        8.height,
                        AppText.regular(
                          'Đăng nhập vào tài khoản của bạn',
                          color: UIColors.textColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(height: 80, color: UIColors.pinkLight),
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: UIColors.creamy,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: SingleChildScrollView(
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.bold('Đăng nhập'),
                              20.height,
                              // Email field
                              AppText.regular(
                                'Email của bạn',
                                fontSize: FontSizes.moreSmall,
                              ),
                              8.height,
                              Obx(
                                () => TextFormField(
                                  controller: controller.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'Nhập email của bạn',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: FontSizes.moreSmall,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade300,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    suffixIcon: controller.emailValid.value
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: UIColors.textColor,
                                            size: 20,
                                          )
                                        : null,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vui lòng nhập email';
                                    }
                                    if (!GetUtils.isEmail(value)) {
                                      return 'Định dạng email không hợp lệ';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              16.height,
                              AppText.regular(
                                'Mật khẩu',
                                fontSize: FontSizes.moreSmall,
                                color: UIColors.textColor,
                              ),
                              8.height,
                              Obx(
                                () => TextFormField(
                                  controller: controller.passwordController,
                                  obscureText: controller.obscurePassword.value,
                                  decoration: InputDecoration(
                                    hintText: 'Nhập mật khẩu của bạn',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: FontSizes.moreSmall,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade300,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.obscurePassword.value
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: UIColors.textColor,
                                        size: 20,
                                      ),
                                      onPressed:
                                          controller.togglePasswordVisibility,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vui lòng nhập mật khẩu';
                                    }
                                    if (value.length < 6) {
                                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              16.height,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => Row(
                                      children: [
                                        Checkbox(
                                          value: controller.rememberMe.value,
                                          onChanged: (value) =>
                                              controller.toggleRememberMe(),
                                          activeColor: UIColors.textColor,
                                        ),
                                        AppText.bold(
                                          'Ghi nhớ đăng nhập',
                                          fontSize: FontSizes.moreSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.snackbar(
                                        'Sắp ra mắt',
                                        'Tính năng quên mật khẩu sắp ra mắt.',
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    },
                                    child: AppText.bold(
                                      'Quên mật khẩu?',
                                      fontSize: FontSizes.moreSmall,
                                      color: UIColors.textColor,
                                    ),
                                  ),
                                ],
                              ),
                              20.height,
                              Obx(
                                () => SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : controller.handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: UIColors.pinkLight,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: controller.isLoading.value
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                UIColors.textColor,
                                              ),
                                            ),
                                          )
                                        : AppText.semiBold(
                                            'Đăng nhập',
                                            fontSize: 16,
                                            color: UIColors.textColor,
                                          ),
                                  ),
                                ),
                              ),
                              24.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText.regular(
                                    fontSize: FontSizes.moreSmall,
                                    'Tôi là người dùng mới. ',
                                    color: UIColors.textColor,
                                  ),
                                  GestureDetector(
                                    onTap: controller.navigateToRegister,
                                    child: AppText.bold(
                                      fontSize: FontSizes.moreSmall,
                                      'Đăng ký',
                                      color: UIColors.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
