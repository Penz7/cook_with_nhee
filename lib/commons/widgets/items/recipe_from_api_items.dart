import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../network/models/recipe_from_api_model.dart';
import '../../extensions/color_extension.dart';
import '../../extensions/number_extension.dart';

class RecipeFromApiItems extends StatelessWidget {
  const RecipeFromApiItems({
    super.key,
    required this.recipe,
  });

  final RecipeFromApiModel recipe;

  static const List<Color> _lightColors = [
    Color(0xFFF5E6E8), // hồng nhạt
    Color(0xFFE6F5F3), // xanh nhạt
    Color(0xFFF5F5E6), // vàng nhạt
    Color(0xFFE6E6F5), // tím nhạt
    Color(0xFFE6F5E6), // xanh lá nhạt
  ];

  Color _getColor(int index) {
    return _lightColors[index % _lightColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final colorIndex = recipe.hashCode.abs() % _lightColors.length;
    final bgColor = _getColor(colorIndex);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: bgColor.opacityColor(0.3),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: bgColor.opacityColor(0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            recipe.name ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.pink.shade900,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.pink.shade200,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 16,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ],
                    ),
                    8.height,
                    if (recipe.description != null &&
                        recipe.description!.isNotEmpty)
                      Text(
                        recipe.description ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.4,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          16.height,
          Row(
            children: [
              if (recipe.ingredients != null && recipe.ingredients!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor.opacityColor(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.restaurant_menu_outlined,
                        size: 14,
                        color: Colors.pink.shade700,
                      ),
                      6.width,
                      Text(
                        '${recipe.ingredients!.length} nguyên liệu',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.pink.shade800,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              if (recipe.tags != null &&
                  recipe.tags!.isNotEmpty &&
                  recipe.ingredients != null &&
                  recipe.ingredients!.isNotEmpty)
                ...[
                  8.width,
                ],
              if (recipe.tags != null && recipe.tags!.isNotEmpty)
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: recipe.tags!.take(2).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag.name ?? '',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.pink.shade700,
                            fontWeight: FontWeight.w500,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
          if (recipe.steps != null && recipe.steps!.isNotEmpty) ...[
            12.height,
            Row(
              children: [
                Icon(
                  Icons.list_alt_outlined,
                  size: 14,
                  color: Colors.pink.shade600,
                ),
                6.width,
                Text(
                  '${recipe.steps!.length} bước',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.pink.shade700,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

