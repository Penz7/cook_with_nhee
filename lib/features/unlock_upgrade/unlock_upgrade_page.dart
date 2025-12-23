import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/features/unlock_upgrade/components/plan_card.dart';
import 'package:cook_with_nhee/features/unlock_upgrade/unlock_upgrade_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnlockUpgradeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UnlockUpgradeController());
  }
}

class UnlockUpgradePage extends GetView<UnlockUpgradeController> {
  const UnlockUpgradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      backgroundColor: const BoxDecoration(color: UIColors.creamy),
      appBar: AppBar(
        backgroundColor: UIColors.creamy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              20.height,
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [UIColors.pink, UIColors.purple],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: UIColors.pink.opacityColor(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              24.height,
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: FontSizes.big,
                    fontWeight: FontWeight.w800,
                    color: UIColors.textColor,
                    height: 1.2,
                  ),
                  children: [
                    TextSpan(text: 'Nâng cấp tài khoản\n'),
                    TextSpan(
                      text: 'của bạn',
                      style: TextStyle(color: UIColors.pink),
                    ),
                  ],
                ),
              ),
              16.height,
              // Description
              AppText.regular(
                'Get personalized AI meal plans, macro tracking, and premium recipes.',
                textAlign: TextAlign.center,
                fontSize: FontSizes.moreSmall,
                maxLines: 2,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
              32.height,
              // Subscription Toggle
              Obx(
                () => Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.toggleSubscription(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !controller.isYearly.value
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: !controller.isYearly.value
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.opacityColor(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: const Text(
                              'Hàng tháng',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => controller.toggleSubscription(true),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.isYearly.value
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(26),
                                  boxShadow: controller.isYearly.value
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.opacityColor(
                                              0.1,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: const Text(
                                  'Hàng năm',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            if (controller.isYearly.value)
                              Positioned(
                                top: -8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: UIColors.pink,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'SAVE 20%',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
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
              ),
              32.height,
              // Basic Plan Card
              PlanCard(
                title: 'Basic',
                subtitle: 'Starter Plan',
                price: 'Free',
                oldPrice: null,
                features: [
                  PlanFeature(text: 'Standard Recipes Access', isLocked: false),
                  PlanFeature(text: 'Basic Calorie Tracking', isLocked: false),
                  PlanFeature(text: 'AI Meal Generation', isLocked: true),
                ],
                isPro: false,
                onSelect: controller.selectBasicPlan,
              ),
              // Pro Plan Card
              Obx(
                () => PlanCard(
                  title: 'Pro',
                  subtitle: 'Full Access',
                  price: controller.isYearly.value
                      ? '\$79.99 /yr'
                      : '\$9.99 /mo',
                  oldPrice: controller.isYearly.value ? '\$119.88' : '\$12.99',
                  features: [
                    PlanFeature(
                      text: 'Tạo công thức AI không giới hạn',
                      isLocked: false,
                    ),
                    PlanFeature(
                      text: 'Theo dõi Macro & Dinh dưỡng nâng cao',
                      isLocked: false,
                    ),
                    PlanFeature(
                      text: 'Trải nghiệm không quảng cáo',
                      isLocked: false,
                    ),
                  ],
                  isPro: true,
                  onSelect: controller.startFreeTrial,
                  onStartTrial: controller.startFreeTrial,
                  trialSubtext: controller.isYearly.value
                      ? 'THEN \$79.99/YEAR'
                      : 'THEN \$9.99/MONTH',
                ),
              ),
              24.height,
              // Footer text
              Text(
                'Hủy bất cứ lúc nào qua cài đặt App Store.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              16.height,
              // Terms and Privacy links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.snackbar(
                        'Điều khoản dịch vụ',
                        'Trang Điều khoản dịch vụ sắp ra mắt.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: Text(
                      'Điều khoản dịch vụ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Text(
                    ' • ',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.snackbar(
                        'Chính sách bảo mật',
                        'Trang Chính sách bảo mật sắp ra mắt.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: Text(
                      'Chính sách bảo mật',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              40.height,
            ],
          ),
        ),
      ),
    );
  }
}
