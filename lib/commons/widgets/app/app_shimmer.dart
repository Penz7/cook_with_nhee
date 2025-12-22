import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../extensions/number_extension.dart';

class AppShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const AppShimmer({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 4,
    this.baseColor,
    this.highlightColor,
  });

  const AppShimmer.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 4,
    this.baseColor,
    this.highlightColor,
  });

  const AppShimmer.circular({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 0,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade300,
      highlightColor: highlightColor ?? Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor ?? Colors.grey.shade300,
          borderRadius: borderRadius > 0
              ? BorderRadius.circular(borderRadius)
              : null,
          shape: borderRadius == 0 ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }
}

/// Shimmer cho recipe loading list
class AppRecipeListShimmer extends StatelessWidget {
  final int itemCount;

  const AppRecipeListShimmer({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: EdgeInsets.only(
            bottom: index < itemCount - 1 ? 12 : 0,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.shade100.opacityColor(0.3),
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
                          const AppShimmer.rectangular(
                            width: double.infinity,
                            height: 20,
                          ),
                          8.height,
                          const AppShimmer.rectangular(
                            width: double.infinity,
                            height: 16,
                          ),
                          4.height,
                          const AppShimmer.rectangular(
                            width: 150,
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    12.width,
                    const AppShimmer.rectangular(
                      width: 36,
                      height: 36,
                      borderRadius: 10,
                    ),
                  ],
                ),
                16.height,
                Row(
                  children: [
                    const AppShimmer.rectangular(
                      width: 80,
                      height: 24,
                      borderRadius: 12,
                    ),
                    8.width,
                    const AppShimmer.rectangular(
                      width: 100,
                      height: 24,
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
  }
}

/// Shimmer cho recipe of the day card
class AppRecipeOfDayShimmer extends StatelessWidget {
  const AppRecipeOfDayShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppShimmer.rectangular(
            width: double.infinity,
            height: 200,
            borderRadius: 24,
          ),
          12.height,
          const AppShimmer.rectangular(
            width: 180,
            height: 16,
            borderRadius: 8,
          ),
          8.height,
          const AppShimmer.rectangular(
            width: double.infinity,
            height: 14,
            borderRadius: 8,
          ),
          8.height,
          const AppShimmer.rectangular(
            width: 140,
            height: 14,
            borderRadius: 8,
          ),
        ],
      ),
    );
  }
}

/// Shimmer cho recommendation recipes
class AppRecommendationShimmer extends StatelessWidget {
  final int itemCount;

  const AppRecommendationShimmer({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      separatorBuilder: (_, _) => 12.width,
      itemBuilder: (_, index) {
        return Container(
          width: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.opacityColor(0.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: SizedBox(
                  height: 130,
                  child: Stack(
                    children: [
                      const AppShimmer.rectangular(
                        width: double.infinity,
                        height: 130,
                        borderRadius: 0,
                      ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: const AppShimmer.rectangular(
                        width: 60,
                        height: 24,
                        borderRadius: 14,
                        baseColor: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: const AppShimmer.circular(
                        width: 36,
                        height: 36,
                        baseColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppShimmer.rectangular(
                      width: double.infinity,
                      height: 16,
                      borderRadius: 4,
                    ),
                    6.height,
                    const AppShimmer.rectangular(
                      width: 150,
                      height: 14,
                      borderRadius: 4,
                    ),
                    12.height,
                    Row(
                      children: [
                        const AppShimmer.rectangular(
                          width: 60,
                          height: 14,
                          borderRadius: 4,
                        ),
                        const Spacer(),
                        const AppShimmer.rectangular(
                          width: 50,
                          height: 14,
                          borderRadius: 4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Shimmer cho discover grid (news/articles)
class AppDiscoverGridShimmer extends StatelessWidget {
  final int itemCount;

  const AppDiscoverGridShimmer({
    super.key,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.64,
      ),
      itemCount: itemCount,
      itemBuilder: (_, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const AppShimmer.rectangular(
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: 0,
                    ),
                  ),
                ),
                // Shimmer cho favorite button
                Positioned(
                  top: 10,
                  right: 10,
                  child: const AppShimmer.circular(
                    width: 36,
                    height: 36,
                  ),
                ),
                // Shimmer cho calories badge
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: const AppShimmer.rectangular(
                    width: 60,
                    height: 28,
                    borderRadius: 16,
                    baseColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Title shimmer
            const AppShimmer.rectangular(
              width: double.infinity,
              height: 18,
              borderRadius: 4,
            ),
            const SizedBox(height: 6),
            const AppShimmer.rectangular(
              width: 120,
              height: 18,
              borderRadius: 4,
            ),
            const SizedBox(height: 4),
            // Duration shimmer
            Row(
              children: [
                const AppShimmer.circular(
                  width: 14,
                  height: 14,
                ),
                const SizedBox(width: 6),
                const AppShimmer.rectangular(
                  width: 60,
                  height: 14,
                  borderRadius: 4,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

