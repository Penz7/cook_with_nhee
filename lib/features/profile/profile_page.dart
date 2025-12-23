import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/context_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/routes/route.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_image.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text_field.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/controller/auth_controller.dart';
import 'package:cook_with_nhee/features/profile/components/body_measurement_card.dart';
import 'package:cook_with_nhee/features/profile/components/bmi_score_card.dart';
import 'package:cook_with_nhee/features/profile/components/content_settings_item.dart';
import 'package:cook_with_nhee/features/profile/profile_controller.dart';
import 'package:cook_with_nhee/network/provider/api_client.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () =>
          ProfileController(Get.find<AuthController>(), Get.find<ApiClient>()),
    );
  }
}

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  String _getMemberStatus(String? role) {
    return 'Thành viên miễn phí';
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      backgroundColor: const BoxDecoration(color: UIColors.creamy),
      body: Obx(() {
        final user = controller.currentUser;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final userName = user.name ?? 'Người dùng';
        final avatarUrl = user.avatar ?? '';
        final memberStatus = _getMemberStatus(user.role);

        return RefreshIndicator(
          onRefresh: controller.refreshProfile,
          color: UIColors.pink,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Obx(() {
                    final selectedFile = controller.selectedImageFile;
                    final selectedBytes = controller.selectedImageBytes;

                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: UIColors.pinkLight, width: 3),
                      ),
                      child: ClipOval(
                        child: selectedFile != null
                            ? AppImage.file(
                                file: selectedFile,
                                width: 100,
                                height: 100,
                              )
                            : selectedBytes != null
                            ? Image.memory(
                                selectedBytes,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : avatarUrl.isNotEmpty
                            ? AppInternetImage(
                                url: avatarUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : _buildDefaultAvatar(),
                      ),
                    );
                  }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: controller.showImagePickerOptions,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: UIColors.pinkLight,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              16.height,
              AppText.bold(userName, fontSize: FontSizes.big),
              4.height,
              AppText.regular(
                memberStatus,
                fontSize: FontSizes.moreSmall,
                color: Colors.grey,
              ),
              32.height,
              LayoutBuilder(
                builder: (context, constraints) {
                  final measurement = user.userMeasurement;
                  final cardWidth =
                      (constraints.maxWidth - 12 * 2) / 3;
                  Future<void> onTapEdit() => _showMeasurementBottomSheet(context);

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildMeasurementCard(
                        label: 'NGỰC',
                        value: measurement?.chest,
                        color: UIColors.pinkLight,
                        width: cardWidth,
                        onTap: onTapEdit,
                      ),
                      _buildMeasurementCard(
                        label: 'EO',
                        value: measurement?.waist,
                        color: UIColors.blue.opacityColor(0.3),
                        width: cardWidth,
                        onTap: onTapEdit,
                      ),
                      _buildMeasurementCard(
                        label: 'HÔNG',
                        value: measurement?.hip,
                        color: UIColors.pink.opacityColor(0.4),
                        width: cardWidth,
                        onTap: onTapEdit,
                      ),
                    ],
                  );
                },
              ),
              24.height,
              Obx(() {
                final advice = controller.healthyAdvice;
                final bmiValue = (user.userMeasurement?.bmi ?? 0.0).toDouble();
                final isUpdating = controller.isUpdatingMeasurement;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    BMIScoreCard(
                      bmiValue: bmiValue,
                      status: advice?.status ?? 'Chưa có dữ liệu',
                      statusLabel: advice?.label ?? 'Chưa đánh giá',
                      description:
                          advice?.description ??
                          'Vui lòng cập nhật thông tin đo lường để nhận lời khuyên sức khỏe.',
                      progress: (advice?.percent ?? 0) / 100.0,
                    ),
                    if (isUpdating)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.opacityColor(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),
                      ),
                  ],
                );
              }),
              24.height,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.unlockUpgrade.p);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UIColors.pink,
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
                      const Icon(Icons.star, size: 20),
                      8.width,
                      const Text(
                        'Mở khóa Kế hoạch Bữa ăn AI - Nâng cấp',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              32.height,
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nội dung & Cài đặt',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ),
              16.height,
              ContentSettingsItem(
                icon: Icons.restaurant_menu,
                title: 'Thông tin cá nhân',
                subtitle: (user.hobbies != null && user.hobbies!.isNotEmpty)
                    ? user.hobbies!.join(', ')
                    : "Hồ sơ, sở thích và hoạt động",
                onTap: () {
                  Get.toNamed(Routes.userFavourite.p);
                },
              ),
              // ContentSettingsItem(
              //   icon: Icons.menu_book,
              //   title: 'Công thức của tôi',
              //   subtitle: '$recipeCount công thức đã lưu',
              //   onTap: () {
              //     Get.toNamed(Routes.myRecipes.p);
              //   },
              // ),
              ContentSettingsItem(
                icon: Icons.calculate,
                title: 'Máy tính BMI',
                subtitle: 'Tính chỉ số khối cơ thể của bạn',
                onTap: () {
                  Get.toNamed(Routes.bmiCalculator.p);
                },
              ),
              20.height,
              ContentSettingsItem(
                icon: Icons.logout_sharp,
                title: 'Đăng xuất tài khoản',
                onTap: () async => _confirmLogout(context),
              ),
              100.height, // Space for bottom navigation
            ],
          ),
        ));
      }),
    );
  }

  Widget _buildMeasurementCard({
    required String label,
    required num? value,
    required Color color,
    required double width,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: width,
      child: BodyMeasurementCard(
        value: value?.toString() ?? '0',
        label: label,
        color: color,
        onTap: onTap,
      ),
    );
  }

  Future<void> _showMeasurementBottomSheet(BuildContext context) async {
    final measurement = controller.currentUser?.userMeasurement;
    final weightController =
        TextEditingController(text: measurement?.weight?.toString() ?? '');
    final heightController =
        TextEditingController(text: measurement?.height?.toString() ?? '');
    final chestController =
        TextEditingController(text: measurement?.chest?.toString() ?? '');
    final waistController =
        TextEditingController(text: measurement?.waist?.toString() ?? '');
    final hipController =
        TextEditingController(text: measurement?.hip?.toString() ?? '');
    final healthyGoalController =
        TextEditingController(text: measurement?.healthyGoal ?? '');

    Widget buildNumberField(String label, TextEditingController controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.bold(label, fontSize: FontSizes.moreSmall),
          8.height,
          AppTextField(
            controller: controller,
            keyboardType: TextInputType.number,
            hintText: 'Nhập $label'.toLowerCase(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            borderRadius: 12,
            elevation: 1,
          ),
        ],
      );
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: UIColors.creamy,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          height: ctx.screenHeight * 2/3,
          padding: EdgeInsets.only(
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              12.height,
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    AppText.bold('Cập nhật số đo', fontSize: FontSizes.medium),
                    16.height,
                    buildNumberField('Cân nặng (kg)', weightController),
                    12.height,
                    buildNumberField('Chiều cao (cm)', heightController),
                    12.height,
                    buildNumberField('Ngực (cm)', chestController),
                    12.height,
                    buildNumberField('Eo (cm)', waistController),
                    12.height,
                    buildNumberField('Hông (cm)', hipController),
                    12.height,
                    // AppText.bold('Mục tiêu sức khỏe (giữ nguyên)'),
                    // 8.height,
                    // AppTextField(
                    //   controller: healthyGoalController,
                    //   enabled: false,
                    //   maxLines: 3,
                    //   elevation: 1,
                    //   borderRadius: 12,
                    //   hintText: 'Chưa có mục tiêu',
                    //   contentPadding:
                    //   const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    // ),
                    40.height,
                  ],
                ),
              ),
              Obx(() {
                final isUpdating = controller.isUpdatingMeasurement;
                return SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      color: UIColors.creamy,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.opacityColor(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(2, 0),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: isUpdating
                          ? null
                          : () async {
                              final weight =
                                  int.tryParse(weightController.text.trim());
                              final height =
                                  int.tryParse(heightController.text.trim());
                              if (weight == null || height == null) {
                                AppToast.error(
                                  'Lỗi',
                                  'Vui lòng nhập cân nặng và chiều cao hợp lệ',
                                );
                                return;
                              }

                              final chest =
                                  int.tryParse(chestController.text.trim());
                              final waist =
                                  int.tryParse(waistController.text.trim());
                              final hip =
                                  int.tryParse(hipController.text.trim());

                              final success =
                                  await controller.updateMeasurement(
                                weight: weight,
                                height: height,
                                chest: chest,
                                waist: waist,
                                hip: hip,
                                healthyGoal: healthyGoalController.text.trim(),
                              );

                              if (success) {
                                Get.back(closeOverlays: true);
                                AppToast.success(
                                  'Thành công',
                                  'Cập nhật số đo thành công',
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: UIColors.pink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isUpdating
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Lưu số đo',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );

  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 100,
      height: 100,
      color: UIColors.pinkLight,
      child: Icon(Icons.person, size: 50, color: UIColors.pink),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.logout, color: Colors.redAccent),
                    10.width,
                    AppText.bold(
                      'Đăng xuất',
                      fontSize: FontSizes.medium,
                    ),
                  ],
                ),
                12.height,
                AppText.regular(
                  'Bạn có chắc muốn đăng xuất khỏi tài khoản này?',
                 fontSize: FontSizes.small,
                  maxLines: 2,
                ),
                20.height,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: UIColors.pinkLight),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Hủy',
                          style: TextStyle(
                            color: UIColors.textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    12.width,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.back();
                          await Get.find<AuthController>().logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: UIColors.pink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Đăng xuất',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
