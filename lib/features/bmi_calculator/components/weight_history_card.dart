import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../bmi_calculator_controller.dart';

class WeightHistoryCard extends StatelessWidget {
  const WeightHistoryCard({
    super.key,
    required this.history,
    required this.weightChange,
  });

  final List<WeightHistoryPoint> history;
  final double weightChange;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'Chưa có lịch sử cân nặng',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    final minWeight = history.map((e) => e.weight).reduce((a, b) => a < b ? a : b);
    final maxWeight = history.map((e) => e.weight).reduce((a, b) => a > b ? a : b);
    final weightRange = maxWeight - minWeight;
    final chartHeight = 120.0;

    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lịch sử cân nặng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: weightChange < 0
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      weightChange < 0 ? Icons.trending_down : Icons.trending_up,
                      size: 16,
                      color: weightChange < 0 ? Colors.green : Colors.red,
                    ),
                    4.width,
                    Text(
                      '${weightChange >= 0 ? '+' : ''}${weightChange.toStringAsFixed(1)}kg',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: weightChange < 0 ? Colors.green.shade900 : Colors.red.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          20.height,
          SizedBox(
            height: chartHeight,
            child: CustomPaint(
              painter: _WeightHistoryPainter(
                history: history,
                minWeight: minWeight,
                maxWeight: maxWeight,
                weightRange: weightRange,
                chartHeight: chartHeight,
              ),
              child: Container(),
            ),
          ),
          12.height,
          // X-axis labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (history.length >= 3) ...[
                Text(
                  DateFormat('MMM d').format(history.first.date),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (history.length >= 5)
                  Text(
                    DateFormat('MMM d').format(history[history.length ~/ 2].date),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                Text(
                  'Hôm nay',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _WeightHistoryPainter extends CustomPainter {
  _WeightHistoryPainter({
    required this.history,
    required this.minWeight,
    required this.maxWeight,
    required this.weightRange,
    required this.chartHeight,
  });

  final List<WeightHistoryPoint> history;
  final double minWeight;
  final double maxWeight;
  final double weightRange;
  final double chartHeight;

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;

    final padding = 20.0;
    final chartWidth = size.width - (padding * 2);
    final chartTop = padding;
    final chartBottom = chartHeight - padding;

    // Draw area under curve
    final areaPath = Path();
    final firstX = padding;
    final firstY = _getYPosition(history.first.weight, chartTop, chartBottom);
    areaPath.moveTo(firstX, chartBottom);
    areaPath.lineTo(firstX, firstY);

    // Draw line and area
    final linePath = Path();
    linePath.moveTo(firstX, firstY);

    for (var i = 0; i < history.length; i++) {
      final x = padding + (chartWidth / (history.length - 1)) * i;
      final y = _getYPosition(history[i].weight, chartTop, chartBottom);
      
      if (i == 0) {
        linePath.moveTo(x, y);
      } else {
        linePath.lineTo(x, y);
      }
      
      areaPath.lineTo(x, y);
    }

    final lastX = padding + chartWidth;
    final lastY = _getYPosition(history.last.weight, chartTop, chartBottom);
    areaPath.lineTo(lastX, chartBottom);
    areaPath.close();

    // Fill area
    final areaPaint = Paint()
      ..color = UIColors.pink.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawPath(areaPath, areaPaint);

    // Draw line
    final linePaint = Paint()
      ..color = UIColors.pink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(linePath, linePaint);

    // Draw points
    final pointPaint = Paint()
      ..color = UIColors.pink
      ..style = PaintingStyle.fill;
    
    for (var i = 0; i < history.length; i++) {
      final x = padding + (chartWidth / (history.length - 1)) * i;
      final y = _getYPosition(history[i].weight, chartTop, chartBottom);
      canvas.drawCircle(Offset(x, y), 5, pointPaint);
      // White center
      canvas.drawCircle(Offset(x, y), 2, Paint()..color = Colors.white);
    }
  }

  double _getYPosition(double weight, double top, double bottom) {
    if (weightRange == 0) return (top + bottom) / 2;
    final normalized = (weight - minWeight) / weightRange;
    return bottom - (normalized * (bottom - top));
  }

  @override
  bool shouldRepaint(_WeightHistoryPainter oldDelegate) {
    return oldDelegate.history != history ||
        oldDelegate.minWeight != minWeight ||
        oldDelegate.maxWeight != maxWeight;
  }
}

