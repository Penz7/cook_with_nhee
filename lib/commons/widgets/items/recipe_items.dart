import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../network/models/recipe_model.dart';
import '../../extensions/color_extension.dart';
import '../../extensions/number_extension.dart';

class RecipeItems extends StatelessWidget {
  const RecipeItems({
    super.key,
    required this.recipe,
    this.showSaveButton = false,
    this.onSave,
    this.isSaving = false,
    this.isSaved = false,
  });

  final RecipeModel recipe;
  final bool showSaveButton;
  final VoidCallback? onSave;
  final bool isSaving;
  final bool isSaved; // Trạng thái đã lưu

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
                    Text(
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
              if (showSaveButton) ...[
                12.width,
                InkWell(
                  onTap: isSaving ? null : onSave,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.pink.shade200,
                        width: 1,
                      ),
                    ),
                    child: isSaving
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.pink.shade400,
                              ),
                            ),
                          )
                        : Icon(
                            isSaved
                                ? Icons.favorite
                                : Icons.bookmark_add_outlined,
                            size: 20,
                            color: isSaved
                                ? Colors.red.shade600
                                : Colors.pink.shade600,
                          ),
                  ),
                ),
              ],
            ],
          ),
          16.height,
          Row(
            children: [
              if (recipe.cookTime != null) ...[
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
                        Icons.restaurant_outlined,
                        size: 14,
                        color: Colors.pink.shade700,
                      ),
                      6.width,
                      Text(
                        'Nấu: ${recipe.cookTime}',
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
              ],
              if (recipe.prepTime != null && recipe.cookTime != null) ...[
                8.width,
              ],
              if (recipe.prepTime != null)
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
                        Icons.timer_outlined,
                        size: 14,
                        color: Colors.pink.shade700,
                      ),
                      6.width,
                      Text(
                        'Chuẩn bị: ${recipe.prepTime}',
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
            ],
          ),
        ],
      ),
    );
  }
}
