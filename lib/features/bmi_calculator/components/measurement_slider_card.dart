import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:flutter/material.dart';

class MeasurementSliderCard extends StatelessWidget {
  const MeasurementSliderCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.onChanged,
    this.isImperial = false,
    this.secondaryValue,
    this.secondaryUnit,
    this.onSecondaryChanged,
  });

  final IconData icon;
  final String label;
  final double value;
  final String unit;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final bool isImperial;
  final int? secondaryValue;
  final String? secondaryUnit;
  final ValueChanged<int>? onSecondaryChanged;

  @override
  Widget build(BuildContext context) {
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.black87, size: 24),
                  12.width,
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (isImperial && secondaryValue != null) ...[
                    Text(
                      '$secondaryValue $secondaryUnit',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      ' $value $unit',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ] else
                    Text(
                      '${value.toInt()} $unit',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                ],
              ),
            ],
          ),
          16.height,
          if (isImperial && onSecondaryChanged != null)
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Feet',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Inches',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                8.height,
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: secondaryValue!.toDouble(),
                        min: 3,
                        max: 7,
                        divisions: 4,
                        activeColor: UIColors.pink,
                        onChanged: (val) => onSecondaryChanged!(val.toInt()),
                      ),
                    ),
                    16.width,
                    Expanded(
                      child: Slider(
                        value: value,
                        min: min,
                        max: max,
                        activeColor: UIColors.pink,
                        onChanged: onChanged,
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            Slider(
              value: value,
              min: min,
              max: max,
              activeColor: UIColors.pink,
              inactiveColor: Colors.grey.shade200,
              onChanged: onChanged,
            ),
        ],
      ),
    );
  }
}

