import 'dart:math' as math;
import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_image.dart';
import 'package:flutter/material.dart';

class FeaturedRecipeCard extends StatelessWidget {
  const FeaturedRecipeCard({
    super.key,
    required this.title,
    required this.calories,
    required this.duration,
    required this.difficulty,
    required this.imageUrl,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.isFavorite = false,
    this.isSaving = false,
    this.onTap,
    this.onToggleFavorite,
  });

  final String title;
  final String calories;
  final String duration;
  final String difficulty;
  final String imageUrl;
  final int protein;
  final int carbs;
  final int fat;
  final bool isFavorite;
  final bool isSaving;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final totalMacros = protein + carbs + fat;
    final proteinPercent = totalMacros > 0 ? protein / totalMacros : 0.33;
    final carbsPercent = totalMacros > 0 ? carbs / totalMacros : 0.33;
    final fatPercent = totalMacros > 0 ? fat / totalMacros : 0.34;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: UIColors.creamy,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.opacityColor(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: AppInternetImage(
                      url: imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      isFood: true,
                    ),
                  ),
                ),
                // Calorie badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 14,
                          color: Colors.orange.shade700,
                        ),
                        4.width,
                        Text(
                          calories,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Content section (40-45% of card)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category tag and bookmark
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: UIColors.pink.opacityColor(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'RECOMMEND',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: UIColors.pink,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: isSaving ? null : onToggleFavorite,
                      //   child: Icon(
                      //     Icons.bookmark,
                      //     size: 24,
                      //     color: isFavorite ? UIColors.pink : Colors.grey.shade600,
                      //   ),
                      // ),
                    ],
                  ),
                  12.height,
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  12.height,
                  // Metadata (Time & Difficulty)
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: Colors.grey.shade700,
                      ),
                      6.width,
                      Text(
                        duration,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      8.width,
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          shape: BoxShape.circle,
                        ),
                      ),
                      8.width,
                      Text(
                        difficulty,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  20.height,
                  // Macros section
                  Row(
                    children: [
                      // Pie chart
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: const Size(80, 80),
                              painter: _MacrosPieChartPainter(
                                proteinPercent: proteinPercent,
                                carbsPercent: carbsPercent,
                                fatPercent: fatPercent,
                              ),
                            ),
                            const Text(
                              'Macros',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.width,
                      // Macros list
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _MacroItem(
                              color: const Color(0xFF90CDF4),
                              label: 'Protein',
                              value: '${protein}g',
                            ),
                            8.height,
                            _MacroItem(
                              color: const Color(0xFFF5B7B1),
                              label: 'Carbs',
                              value: '${carbs}g',
                            ),
                            8.height,
                            _MacroItem(
                              color: const Color(0xFFD7BDE2),
                              label: 'Fat',
                              value: '${fat}g',
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _MacroItem extends StatelessWidget {
  const _MacroItem({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        8.width,
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade900,
          ),
        ),
      ],
    );
  }
}

class _MacrosPieChartPainter extends CustomPainter {
  _MacrosPieChartPainter({
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatPercent,
  });

  final double proteinPercent;
  final double carbsPercent;
  final double fatPercent;

  static const Color proteinColor = Color(0xFF90CDF4);
  static const Color carbsColor = Color(0xFFF5B7B1);
  static const Color fatColor = Color(0xFFD7BDE2);
  static const double strokeWidth = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -math.pi / 2; // Start from top

    // Draw protein segment
    final proteinSweep = proteinPercent * 2 * math.pi;
    final proteinPaint = Paint()
      ..color = proteinColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, proteinSweep, false, proteinPaint);
    startAngle += proteinSweep;

    // Draw carbs segment
    final carbsSweep = carbsPercent * 2 * math.pi;
    final carbsPaint = Paint()
      ..color = carbsColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, carbsSweep, false, carbsPaint);
    startAngle += carbsSweep;

    // Draw fat segment
    final fatSweep = fatPercent * 2 * math.pi;
    final fatPaint = Paint()
      ..color = fatColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, fatSweep, false, fatPaint);
  }

  @override
  bool shouldRepaint(_MacrosPieChartPainter oldDelegate) {
    return oldDelegate.proteinPercent != proteinPercent ||
        oldDelegate.carbsPercent != carbsPercent ||
        oldDelegate.fatPercent != fatPercent;
  }
}

