import 'package:flutter/material.dart';

import '../../../commons/extensions/number_extension.dart';
import '../../../commons/style/colors.dart';
import '../../../commons/style/font_sizes.dart';
import '../../../commons/widgets/app/app_text.dart';

class IngredientItem extends StatelessWidget {
  final String name;
  final String description;

  const IngredientItem({
    super.key,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Checkbox tròn
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: UIColors.pink, width: 1),
            color: UIColors.pink,
          ),
        ),
        16.width,
        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.bold(
                name,
                fontSize: FontSizes.moreSmall,
                color: Colors.black87,
                maxLines: 2,
              ),
              if (description.isNotEmpty) ...[
                4.height,
                Expanded(
                  child: AppText.regular(
                    description,
                    fontSize: FontSizes.extraSmall,
                    color: Colors.grey.shade600,
                    maxLines: 2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
