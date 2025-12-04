import 'package:flutter/material.dart';
import '../../extensions/number_extension.dart';

class RecipeLoadingShimmer extends StatefulWidget {
  final int itemCount;

  const RecipeLoadingShimmer({
    super.key,
    this.itemCount = 3,
  });

  @override
  State<RecipeLoadingShimmer> createState() => _RecipeLoadingShimmerState();
}

class _RecipeLoadingShimmerState extends State<RecipeLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: List.generate(
            widget.itemCount,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index < widget.itemCount - 1 ? 12 : 0,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade100.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ShimmerBox(
                                width: double.infinity,
                                height: 20,
                                opacity: _animation.value,
                              ),
                              8.height,
                              _ShimmerBox(
                                width: double.infinity,
                                height: 16,
                                opacity: _animation.value,
                              ),
                              4.height,
                              _ShimmerBox(
                                width: 150,
                                height: 16,
                                opacity: _animation.value,
                              ),
                            ],
                          ),
                        ),
                        12.width,
                        _ShimmerBox(
                          width: 36,
                          height: 36,
                          opacity: _animation.value,
                          borderRadius: 10,
                        ),
                      ],
                    ),
                    16.height,
                    Row(
                      children: [
                        _ShimmerBox(
                          width: 80,
                          height: 24,
                          opacity: _animation.value,
                          borderRadius: 12,
                        ),
                        8.width,
                        _ShimmerBox(
                          width: 100,
                          height: 24,
                          opacity: _animation.value,
                          borderRadius: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double opacity;
  final double borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.opacity,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300.withOpacity(opacity),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

