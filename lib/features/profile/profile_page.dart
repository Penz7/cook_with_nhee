import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_image.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/commons/widgets/card/app_card.dart';
import 'package:cook_with_nhee/controller/auth_controller.dart';
import 'package:cook_with_nhee/features/profile/profile_controller.dart';
import 'package:cook_with_nhee/network/provider/api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      appBar: AppBar(
        title: AppText.bold('Hồ sơ'),
        backgroundColor: UIColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: UIColors.textColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isEditMode ? Icons.close : Icons.edit,
                color: UIColors.textColor,
              ),
              onPressed: controller.toggleEditMode,
            ),
          ),
        ],
      ),
      body: Obx(() {
        final user = controller.currentUser;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Obx(() {
                    final selectedFile = controller.selectedImageFile;
                    final selectedBytes = controller.selectedImageBytes;
                    final avatarUrl = user.avatar ?? '';

                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.pink.shade300,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.shade200.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: selectedFile != null
                            ? AppImage.file(
                                file: selectedFile,
                                width: 120,
                                height: 120,
                              )
                            : selectedBytes != null
                                ? Image.memory(
                                    selectedBytes,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                            : avatarUrl.isNotEmpty
                                ? AppInternetImage(
                                    url: avatarUrl,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : _buildDefaultAvatar(),
                      ),
                    );
                  }),
                  if (controller.isEditMode)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: controller.showImagePickerOptions,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade400,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              24.height,
              Obx(
                () => AppText.bold(
                  controller.isEditMode
                      ? controller.nameController.text.isEmpty
                            ? 'Chưa có tên'
                            : controller.nameController.text
                      : user.name ?? 'Chưa có tên',
                  fontSize: 24,
                  color: Colors.pink.shade800,
                ),
              ),
              8.height,
              // Email (read-only)
              AppText.regular(
                user.email ?? '',
                fontSize: 14,
                color: Colors.pink.shade600,
              ),
              32.height,
              // Profile information card
              AppCard(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.bold('Thông tin cá nhân'),
                    20.height,
                    _buildInfoField(
                      label: 'Họ và tên',
                      icon: Icons.person,
                      controller: controller.nameController,
                      enabled: controller.isEditMode,
                    ),
                    16.height,
                    _buildInfoField(
                      label: 'Số điện thoại',
                      icon: Icons.phone,
                      controller: controller.phoneController,
                      enabled: controller.isEditMode,
                      keyboardType: TextInputType.phone,
                    ),
                    16.height,
                    _buildInfoField(
                      label: 'Sở thích',
                      icon: Icons.favorite,
                      controller: controller.hobbyController,
                      enabled: controller.isEditMode,
                      maxLines: 3,
                    ),
                    16.height,
                    _buildInfoField(
                      label: 'Email',
                      icon: Icons.email,
                      controller: controller.emailController,
                      enabled: false,
                    ),
                    16.height,
                    _buildReadOnlyField(
                      label: 'Số công thức còn lại',
                      icon: Icons.menu_book,
                      value: '${user.recipeQuantity ?? 0}',
                    ),
                    24.height,
                    if (controller.isEditMode)
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink.shade400,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                            onPressed: controller.isLoading
                                ? null
                                : controller.saveProfile,
                            child: controller.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.save,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      8.width,
                                      Text(
                                        'Lưu thay đổi',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 120,
      height: 120,
      color: Colors.pink.shade100,
      child: Icon(Icons.person, size: 60, color: Colors.pink.shade300),
    );
  }

  Widget _buildInfoField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required bool enabled,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.pink.shade600),
            8.width,
            AppText.bold(label, fontSize: FontSizes.small),
          ],
        ),
        8.height,
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: FontSizes.small,
            color: enabled ? UIColors.textColor : UIColors.textColor,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.pink.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.pink.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.pink.shade400, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            hintText: 'Nhập $label',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required IconData icon,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.pink.shade600),
            8.width,
            AppText.semiBold(
              label,
              fontSize: 14,
              color: Colors.pink.shade700,
            ),
          ],
        ),
        8.height,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Expanded(
                child: AppText.regular(
                  value,
                  fontSize: 15,
                  color: UIColors.textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
