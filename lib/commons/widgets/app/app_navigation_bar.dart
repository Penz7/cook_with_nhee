import 'dart:ui';

import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import '../../style/colors.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final items = _NavigationItem.items;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.opacityColor(0.9),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.opacityColor(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: Colors.white.opacityColor(0.6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isActive = currentIndex == index;
                final iconColor = isActive
                    ? UIColors.pink
                    : Colors.grey.shade500;
                final labelStyle = TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: iconColor,
                );

                return GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(
                      horizontal: isActive ? 12 : 10,
                      vertical: isActive ? 4 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? UIColors.pink.opacityColor(0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(item.icon, size: 24, color: iconColor),
                        const SizedBox(height: 4),
                        if (item.label != null)
                          Text(item.label!, style: labelStyle),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationItem {
  _NavigationItem({required this.icon, this.label});

  final IconData icon;
  final String? label;

  static final items = <_NavigationItem>[
    _NavigationItem(icon: Icons.home_filled, label: 'Trang chủ'),
    _NavigationItem(icon: Icons.explore, label: 'Khám phá'),
    // _NavigationItem(icon: Icons.restaurant_menu_rounded, label: 'Generate'),
    _NavigationItem(icon: Icons.bookmark, label: 'Đã lưu'),
    _NavigationItem(icon: Icons.person, label: 'Hồ sơ'),
  ];
}
