import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BMIDisplayCard extends StatelessWidget {
  const BMIDisplayCard({
    super.key,
    required this.bmiValue,
    required this.category,
    required this.description,
    required this.color,
  });

  final double bmiValue;
  final String category;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Calculate progress (0.0 to 1.0) - normalize BMI to 0-40 range
    final progress = (bmiValue / 40).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular BMI display
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.grey.shade200,
                    ),
                  ),
                ),
                // Progress circle
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                // BMI value
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bmiValue.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    4.height,
                    Text(
                      'BMI SCORE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade300,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          24.height,
          // Category
          Text(
            category,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          8.height,
          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

