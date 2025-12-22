import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BMIScoreCard extends StatelessWidget {
  const BMIScoreCard({
    super.key,
    required this.bmiValue,
    required this.status,
    required this.statusLabel,
    required this.description,
    this.progress = 0.5,
  });

  final double bmiValue;
  final String status;
  final String statusLabel;
  final String description;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final clampedBmi = _clampBmi(bmiValue);
    final Color statusColor = _colorForBMI(clampedBmi);
    final bmiFraction = _bmiFraction(clampedBmi);
    final angle = math.pi * bmiFraction;
    const gaugeRadius = 100.0;
    const strokeWidth = 20.0;
    const dotSize = 16.0;
    final arcRadius = gaugeRadius - strokeWidth / 2;
    final center = const Offset(gaugeRadius, gaugeRadius);
    final angleRad = math.pi + angle;
    final dotOffset = Offset(
      center.dx + arcRadius * math.cos(angleRad) - dotSize / 2,
      center.dy + arcRadius * math.sin(angleRad) - dotSize / 2,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.opacityColor(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(gaugeRadius * 2, gaugeRadius),
                  painter: _SegmentedArcPainter(
                    strokeWidth: strokeWidth,
                    bmiValue: bmiValue,
                  ),
                ),
                Positioned(
                  top: gaugeRadius / 2,
                  child: Text(
                    bmiValue.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Positioned(
                  left: dotOffset.dx,
                  top: dotOffset.dy,
                  child: Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          24.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText.bold('Chỉ số BMI', fontSize: FontSizes.small),
              8.width,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppText.regular(
                  statusLabel,
                  fontSize: FontSizes.extraSmall,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          12.height,
          // Status
          AppText.bold(status, color: statusColor, fontSize: FontSizes.small),
          12.height,
          GestureDetector(
            onTap: () => _showFullDescription(context),
            child: AppText.regular(
              description,
              textAlign: TextAlign.center,
              fontSize: FontSizes.moreSmall,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  double _clampBmi(double bmi) {
    return bmi.clamp(_minBmi, _maxBmi);
  }

  Color _colorForBMI(double bmi) {
    if (bmi <= 0) return Colors.grey.shade400;
    if (bmi < 18.5) return Colors.redAccent;
    if (bmi < 23) return Colors.green;
    if (bmi < 25) return Colors.orange;
    return Colors.deepOrange;
  }

  double _bmiFraction(double bmi) {
    final clamped = _clampBmi(bmi);
    return (clamped - _minBmi) / (_maxBmi - _minBmi);
  }

  static const double _minBmi = 10.0;
  static const double _maxBmi = 40.0;

  void _showFullDescription(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.health_and_safety, color: Colors.green),
                  8.width,
                  AppText.bold('Chi tiết lời khuyên', fontSize: FontSizes.small),
                ],
              ),
              12.height,
              AppText.regular(
                description,
                fontSize: FontSizes.moreSmall,
                textAlign: TextAlign.left,
                maxLines: 50,
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentedArcPainter extends CustomPainter {
  _SegmentedArcPainter({
    required this.strokeWidth,
    required this.bmiValue,
  });

  final double strokeWidth;
  final double bmiValue;

  static const double _minBmi = 10.0;
  static const double _lowUpper = 18.5;
  static const double _healthyUpper = 22.9;
  static const double _maxBmi = 40.0;

  double _fraction(double bmi) {
    final clamped = bmi.clamp(_minBmi, _maxBmi);
    return (clamped - _minBmi) / (_maxBmi - _minBmi);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);

    void drawSegment(double startBmi, double endBmi, Color color) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final startAngle = math.pi + math.pi * _fraction(startBmi);
      final sweepAngle = math.pi * (_fraction(endBmi) - _fraction(startBmi));

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
    }

    // Red: underweight
    drawSegment(_minBmi, _lowUpper, Colors.redAccent);
    // Green: healthy
    drawSegment(_lowUpper, _healthyUpper, Colors.green);
    // Orange: overweight & obese
    drawSegment(_healthyUpper, _maxBmi, Colors.orange);
  }

  @override
  bool shouldRepaint(covariant _SegmentedArcPainter oldDelegate) {
    return oldDelegate.bmiValue != bmiValue || oldDelegate.strokeWidth != strokeWidth;
  }
}
