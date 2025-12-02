import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../network/models/recipe_model.dart';
import '../../extensions/color_extension.dart';
import '../../extensions/number_extension.dart';

class RecipeItems extends StatelessWidget {
  const RecipeItems({super.key, required this.recipe});

  final RecipeModel recipe;

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
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor.opacityColor(0.8),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.opacityColor(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            recipe.name ?? '',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
          10.height,
          Text(
            recipe.description ?? '',
            style: TextStyle(
              fontSize: 16,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
          20.height,
          Row(
            children: [
              Icon(Icons.timelapse, size: 15, color: Colors.black),
              12.width,
              Text(
                'Nấu: ${recipe.cookTime}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
              20.width,
              Icon(Icons.pause_presentation, size: 15, color: Colors.black),
              12.width,
              Text(
                'Chuẩn bị: ${recipe.prepTime}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
