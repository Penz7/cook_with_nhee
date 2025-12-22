import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/features/intro/intro_controller.dart';
import 'package:cook_with_nhee/features/intro/pages/body_stats_page.dart';
import 'package:cook_with_nhee/features/intro/pages/food_preferences_page.dart';
import 'package:cook_with_nhee/features/intro/pages/goal_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => IntroController(Get.find(), Get.find(), Get.find()),
      fenix: true,
    );
  }
}

class IntroPage extends GetView<IntroController> {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      backgroundColor: BoxDecoration(color: UIColors.creamy),
      body: Column(
        children: [
          40.height,
          _buildAppBar(),
          20.height,
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              children: const [
                GoalSelectionPage(),
                BodyStatsPage(),
                FoodPreferencesPage(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Obx(
            () => _AnimatedProgressBar(
              progress: controller.progress,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: UIColors.creamy,
          boxShadow: [
            BoxShadow(
              color: Colors.black.opacityColor(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (controller.currentStep.value > 0) ...[
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: controller.previousStep,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: UIColors.pink),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: AppText.semiBold(
                        'Quay lại',
                        fontSize: 16,
                        color: UIColors.pink,
                      ),
                    ),
                  ),
                ),
                12.width,
              ],
              // Nút Next
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : (controller.canGoToNextStep()
                                ? controller.nextStep
                                : null),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: UIColors.pink,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : AppText.semiBold(
                              controller.currentStep.value ==
                                      controller.totalSteps - 1
                                  ? 'Tạo kế hoạch của tôi'
                                  : 'Tiếp theo',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedProgressBar extends StatefulWidget {
  final double progress;

  const _AnimatedProgressBar({
    required this.progress,
  });

  @override
  State<_AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<_AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _previousProgress = 0.0;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    // Animate từ 0 đến giá trị ban đầu
    _animationController.forward();
  }

  @override
  void didUpdateWidget(_AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _previousProgress = oldWidget.progress;
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final animatedValue = _previousProgress +
                  (widget.progress - _previousProgress) * _animation.value;
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: animatedValue,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(UIColors.pink),
                  minHeight: 8,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
