import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/context_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/routes/route.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_image.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'authentication_controller.dart';

class AuthenticationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthenticationController());
  }
}

class AuthenticationPage extends GetView<AuthenticationController> {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      backgroundColor: BoxDecoration(color: UIColors.creamy),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) {
                  final slideIndex = index % controller.slides.length;
                  return _buildSlide(context, controller.slides[slideIndex]);
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildLoginSection(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSlide(BuildContext context, Map<String, String> slide) {
    final imagePath = slide['image'] ?? '';
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: context.screenWidth,
              height: context.screenHeight * 0.6,
              child: imagePath.isNotEmpty
                  ? AppInternetImage(
                      url: imagePath,
                      fit: BoxFit.cover,
                      isBlur: true,
                    )
                  : _buildGradientPlaceholder(),
            ),
            Positioned(
              bottom: 70,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 280,
                    child: AppText.bold(
                      slide['title'] ?? '',
                      color: Colors.white,
                      maxLines: 3,
                    ),
                  ),
                  10.height,
                  SizedBox(
                    width: 350,
                    child: AppText.regular(
                      slide['description'] ?? '',
                      color: Colors.white,
                      fontSize: FontSizes.moreSmall,
                      maxLines: 4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGradientPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2C1810),
            const Color(0xFF1A0F0A),
            const Color(0xFF0D0503),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(controller.slides.length, (index) {
          final isActive = controller.currentPageIndex.value == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? UIColors.pink : Colors.grey.opacityColor(0.4),
              borderRadius: BorderRadius.circular(isActive ? 4 : 4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoginSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.opacityColor(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPageIndicator(),
          20.height,
          _buildSocialButton(
            Assets.icons.icApple.path,
            'Đăng nhập với Apple',
            () {
              AppToast.info('Sắp ra mắt!', 'Tính năng đang được hoàn thiện để mang lại trải nghiệm tốt nhất cho bạn.');
            },
          ),
          12.height,
          _buildSocialButton(
            Assets.icons.icGoogle.path,
            'Đăng nhập với Google',
            () {
              AppToast.info('Sắp ra mắt!', 'Tính năng đang được hoàn thiện để mang lại trải nghiệm tốt nhất cho bạn.');
            },
          ),
          12.height,
          _buildSocialButton(
            Assets.icons.icFacebook.path,
            'Đăng nhập với Facebook',
            () {
              AppToast.info('Sắp ra mắt!', 'Tính năng đang được hoàn thiện để mang lại trải nghiệm tốt nhất cho bạn.');
            },
          ),
          12.height,
          const Divider(indent: 30, endIndent: 30),
          4.height,
          InkWell(
            onTap: () {
              Get.toNamed(Routes.login.p);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 18,
                  color: Color(0xFF3A3A3A),
                ),
                8.width,
                AppText.medium(
                  'Đăng nhập với email của bạn',
                  fontSize: FontSizes.moreSmall,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          12.height,
          AppText.regular(
            'Bắt đầu hành trình cùng CookWithNhee là bạn đã đồng ý với các Điều khoản và Bảo mật của chúng mình.',
            fontSize: 11,
            color: Colors.grey.shade600,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          10.height,
        ],
      ),
    );
  }

  Widget _buildSocialButton(String icon, String title, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: UIColors.blue,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.opacityColor(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: .center,
            children: [
              Image.asset(
                icon,
                color: Colors.black,
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
              10.width,
              AppText.regular(
                title,
                color: Colors.black,
                fontSize: FontSizes.moreSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
