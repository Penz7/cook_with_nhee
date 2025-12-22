import 'package:cook_with_nhee/commons/widgets/app/app_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../discover/discover_controller.dart';
import '../discover/discover_page.dart';
import '../home/home_controller.dart';
import '../home/home_page.dart';
import '../my_recipes/my_recipes_controller.dart';
import '../my_recipes/my_recipes_page.dart';
import '../profile/profile_controller.dart';
import '../profile/profile_page.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    HomeBinding().dependencies();
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget?> _pages = [null, null, null, null];
  Widget _getPage(int index) {
    if (_pages[index] == null) {
      switch (index) {
        case 0:
          if (!Get.isRegistered<HomeController>()) {
            HomeBinding().dependencies();
          }
          _pages[0] = const HomePage();
          break;
        case 1:
          if (!Get.isRegistered<DiscoverController>()) {
            DiscoverBinding().dependencies();
          }
          _pages[1] = const DiscoverPage();
          break;
        case 2:
          if (!Get.isRegistered<MyRecipesController>()) {
            MyRecipesBinding().dependencies();
          }
          _pages[2] = const MyRecipesPage();
          break;
        case 3:
          if (!Get.isRegistered<ProfileController>()) {
            ProfileBinding().dependencies();
          }
          _pages[3] = const ProfilePage();
          break;
      }
    }
    return _pages[index]!;
  }

  @override
  void initState() {
    super.initState();
    _getPage(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [
              _pages[0] ?? const SizedBox.shrink(),
              _pages[1] ?? const SizedBox.shrink(),
              _pages[2] ?? const SizedBox.shrink(),
              _pages[3] ?? const SizedBox.shrink(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AppNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  _getPage(index);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
