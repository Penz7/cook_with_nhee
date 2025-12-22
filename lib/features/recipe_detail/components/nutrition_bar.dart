import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:flutter/material.dart';

import '../../../commons/extensions/number_extension.dart';
import '../../../commons/style/colors.dart';
import '../../../commons/style/font_sizes.dart';
import '../../../commons/widgets/app/app_text.dart';

class NutritionBar extends StatefulWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color? progressColor;
  final Duration animationDuration;

  const NutritionBar({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    this.progressColor,
    this.animationDuration = const Duration(milliseconds: 1200),
  });

  @override
  State<NutritionBar> createState() => _NutritionBarState();
}

class _NutritionBarState extends State<NutritionBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    final percentage = (widget.value / widget.maxValue).clamp(0.0, 1.0);

    _progressAnimation = Tween<double>(begin: 0.0, end: percentage).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.bold(
              widget.label,
              fontSize: FontSizes.moreSmall,
              color: Colors.black87,
            ),
            AppText.bold(
              '${widget.value}g',
              fontSize: FontSizes.moreSmall,
              color: Colors.black87,
            ),
          ],
        ),
        8.height,
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _progressAnimation.value,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.progressColor ?? UIColors.pinkLight,
                            (widget.progressColor ?? UIColors.pinkLight)
                                .opacityColor(0.8),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: (widget.progressColor ?? UIColors.pinkLight)
                                .opacityColor(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
