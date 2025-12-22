import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../style/colors.dart';

class AppFilter extends SliverPersistentHeaderDelegate {
  AppFilter({
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final List<String> filters;
  final RxString selectedFilter;
  final ValueChanged<String> onFilterChanged;

  @override
  double get minExtent => 80;

  @override
  double get maxExtent => 80;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: UIColors.creamy,
      child: ListView.separated(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => 10.width,
        itemBuilder: (_, index) {
          final label = filters[index];
          return Obx(
            () => _FilterChip(
              label: label,
              selected: selectedFilter.value == label,
              onTap: () => onFilterChanged(label),
            ),
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(AppFilter oldDelegate) {
    return filters != oldDelegate.filters ||
        selectedFilter != oldDelegate.selectedFilter;
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        margin: EdgeInsetsGeometry.symmetric(vertical: 18),
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected ? UIColors.pink : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? UIColors.pink : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.opacityColor(0.04),
              spreadRadius: 4,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            fontSize: FontSizes.moreSmall,
          ),
        ),
      ),
    );
  }
}
