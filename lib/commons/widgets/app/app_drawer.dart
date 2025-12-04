import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/routes/route.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_image.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDrawer extends StatelessWidget {
  final AuthController authController;

  const AppDrawer({
    super.key,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Obx(() {
              final currentUser = authController.currentUser;
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.pink.shade50,
                      Colors.pink.shade100,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppInternetImage(
                      url: currentUser?.avatar ?? '',
                      width: 70,
                      height: 70,
                      borderRadius: 50,
                    ),
                    16.height,
                    AppText.semiBold(
                      currentUser?.name ?? 'Người dùng',
                      fontSize: 18,
                      color: Colors.pink.shade900,
                    ),
                    4.height,
                    AppText.regular(
                      currentUser?.email ?? '',
                      fontSize: 14,
                      color: Colors.pink.shade700,
                    ),
                  ],
                ),
              );
            }),
            
            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _DrawerItem(
                    icon: Icons.person_outline,
                    title: 'Hồ sơ',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed(Routes.profile.p);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.menu_book_outlined,
                    title: 'Công thức của tôi',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed(Routes.myRecipes.p);
                    },
                  ),
                  // _DrawerItem(
                  //   icon: Icons.settings_outlined,
                  //   title: 'Cài đặt',
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     // TODO: Navigate to settings page
                  //   },
                  // ),
                  const Divider(height: 32),
                  _DrawerItem(
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () async {
                      Navigator.pop(context);
                      await authController.logout();
                    },
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

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Colors.pink.shade700,
        size: 24,
      ),
      title: AppText.medium(
        title,
        fontSize: 16,
        color: textColor ?? UIColors.textColor,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}

