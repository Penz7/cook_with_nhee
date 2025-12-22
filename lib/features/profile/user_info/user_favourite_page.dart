import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/features/profile/user_info/user_favourite_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserFavouritePage extends GetView<UserFavouriteController> {
  const UserFavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      backgroundColor: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF3E9), Color(0xFFFFFBF6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      body: Obx(() {
        final user = controller.currentUser;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBackButton(),
                ],
              ),
              30.height,
              _buildEditableCard(
                title: 'Hồ sơ cơ bản',
                subtitle: 'Cập nhật thông tin nhận diện của bạn',
                icon: Icons.person,
                children: [
                  _buildTextField(
                    label: 'Họ tên',
                    hint: 'Nhập họ tên',
                    controller: controller.fullNameController,
                    prefixIcon: Icons.badge_outlined,
                  ),
                  // _buildTextField(
                  //   label: 'Giới tính',
                  //   hint: 'Chọn giới tính',
                  //   controller: controller.genderController,
                  //   prefixIcon: Icons.wc,
                  // ),
                  8.height,
                  _buildGenderSelector(),
                  16.height,
                  _buildTextField(
                    label: 'Ngày sinh',
                    hint: 'yyyy-MM-dd',
                    controller: controller.dateOfBirthController,
                    prefixIcon: Icons.calendar_today_rounded,
                  ),
                ],
              ),
              16.height,
              _buildEditableCard(
                title: 'Sở thích & Hoạt động',
                subtitle: 'Hiển thị bạn yêu thích điều gì',
                icon: Icons.favorite_outline,
                children: [
                  _buildTextField(
                    label: 'Hobbies (phân tách dấu phẩy)',
                    hint: 'gym, cooking, fitness',
                    controller: controller.hobbiesController,
                    prefixIcon: Icons.spa_outlined,
                  ),
                  _buildChipsPreview(_split(controller.hobbiesController.text)),
                  _buildTextField(
                    label: 'Hoạt động yêu thích (phân tách dấu phẩy)',
                    hint: 'running, swimming',
                    controller: controller.activitiesController,
                    prefixIcon: Icons.run_circle_outlined,
                  ),
                  _buildChipsPreview(
                    _split(controller.activitiesController.text),
                    color: UIColors.pinkLight,
                  ),
                ],
              ),
              16.height,
              _buildEditableCard(
                title: 'Chế độ ăn uống',
                subtitle: 'Tùy chỉnh khẩu vị & dị ứng',
                icon: Icons.restaurant_menu,
                children: [
                  _buildTextField(
                    label: 'Loại chế độ',
                    hint: 'keto / vegan / ...',
                    controller: controller.dietTypeController,
                    prefixIcon: Icons.local_dining,
                  ),
                  _buildTextField(
                    label: 'Ẩm thực mặc định',
                    hint: 'vietnamese',
                    controller: controller.defaultCuisineController,
                    prefixIcon: Icons.flag_outlined,
                  ),
                  _buildTextField(
                    label: 'Ẩm thực khác (phân tách dấu phẩy)',
                    hint: 'japanese, korean',
                    controller: controller.otherCuisinesController,
                    prefixIcon: Icons.ramen_dining,
                  ),
                  _buildChipsPreview(
                    _split(controller.otherCuisinesController.text),
                    color: Colors.orange.shade100,
                  ),
                  _buildTextField(
                    label: 'Dị ứng (phân tách dấu phẩy)',
                    hint: 'shrimp, egg',
                    controller: controller.allergiesController,
                    prefixIcon: Icons.healing_outlined,
                  ),
                  _buildChipsPreview(
                    _split(controller.allergiesController.text),
                    color: Colors.red.shade100,
                  ),
                  _buildTextField(
                    label: 'Không thích (phân tách dấu phẩy)',
                    hint: 'mushroom, bitter-melon',
                    controller: controller.dislikedIngredientsController,
                    prefixIcon: Icons.block_outlined,
                  ),
                  _buildChipsPreview(
                    _split(controller.dislikedIngredientsController.text),
                    color: Colors.blue.shade50,
                  ),
                ],
              ),
              20.height,
              _buildActionButtons(),
              32.height,
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: Get.back,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: UIColors.pink,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildEditableCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: UIColors.pinkLight.opacityColor(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: UIColors.pink),
              ),
              10.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.bold(title, fontSize: FontSizes.medium),
                    2.height,
                    AppText.medium(
                      subtitle,
                      fontSize: FontSizes.extraSmall,
                      color: Colors.grey.shade700,
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.height,
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? prefixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.medium(
            label,
            fontSize: FontSizes.small,
            color: Colors.grey.shade700,
          ),
          6.height,
          TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: UIColors.pink)
                  : null,
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: UIColors.pink),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    final options = ['Nam', 'Nữ'];
    return Obx(
      () => Wrap(
        spacing: 12,
        children: options.map((option) {
          final isSelected = controller.genderDisplay == option;
          return ChoiceChip(
            label: Text(option),
            selected: isSelected,
            onSelected: (_) => controller.setGenderDisplay(option),
            selectedColor: UIColors.pinkLight,
            backgroundColor: Colors.grey.shade200,
            labelStyle: TextStyle(
              color: UIColors.textColor,
              fontWeight: FontWeight.w700,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChipsPreview(List<String> values, {Color? color}) {
    if (values.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: values
            .map(
              (v) => Chip(
                label: Text(v),
                backgroundColor: color?.opacityColor(0.3) ?? UIColors.blue.opacityColor(0.2),
                labelStyle: TextStyle(
                  color: UIColors.textColor,
                  fontWeight: FontWeight.w600,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: controller.isSaving
                  ? null
                  : controller.saveProfileAndDiet,
              style: ElevatedButton.styleFrom(
                backgroundColor: UIColors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: controller.isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(
                controller.isSaving ? 'Đang lưu...' : 'Lưu thay đổi',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          12.width,
          ElevatedButton(
            onPressed: controller.isSaving
                ? null
                : () async {
                    await controller.authController.getMe();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: UIColors.pink,
              padding: const EdgeInsets.all(14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: UIColors.pink),
              ),
              elevation: 0,
            ),
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  List<String> _split(String value) {
    return value
        .split(',')
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();
  }
}
