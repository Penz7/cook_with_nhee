import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:flutter/material.dart';

import '../../../commons/extensions/color_extension.dart';
import '../../../commons/extensions/number_extension.dart';
import '../../../commons/widgets/app/app_text.dart';

class ChipTargetAudience extends StatelessWidget {
  final String label;

  const ChipTargetAudience({super.key, required this.label});

  static final List<Color> _pastelColors = [
    Colors.blue.opacityColor(0.15),
    Colors.pink.opacityColor(0.15),
    Colors.green.opacityColor(0.15),
    Colors.orange.opacityColor(0.15),
    Colors.purple.opacityColor(0.15),
    Colors.teal.opacityColor(0.15),
    Colors.indigo.opacityColor(0.15),
    Colors.amber.opacityColor(0.15),
    Colors.cyan.opacityColor(0.15),
    Colors.lime.opacityColor(0.15),
  ];

  static final List<Color> _textColors = [
    Colors.blue.shade700,
    Colors.pink.shade700,
    Colors.green.shade700,
    Colors.orange.shade700,
    Colors.purple.shade700,
    Colors.teal.shade700,
    Colors.indigo.shade700,
    Colors.amber.shade700,
    Colors.cyan.shade700,
    Colors.lime.shade700,
  ];

  static final List<IconData> _icons = [
    Icons.bolt,
    Icons.favorite,
    Icons.eco,
    Icons.local_fire_department,
    Icons.star,
    Icons.water_drop,
    Icons.flash_on,
    Icons.wb_sunny,
    Icons.ac_unit,
    Icons.nature,
  ];

  @override
  Widget build(BuildContext context) {
    final int colorIndex = label.hashCode.abs() % _pastelColors.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _pastelColors[colorIndex],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _textColors[colorIndex].opacityColor(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _icons[colorIndex],
            size: 14,
            color: _textColors[colorIndex],
          ),
          6.width,
          AppText.bold(
            label,
            fontSize: FontSizes.extraSmall,
            color: _textColors[colorIndex],
          ),
        ],
      ),
    );
  }
}
