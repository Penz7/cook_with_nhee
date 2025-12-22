import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_shimmer.dart';
import 'package:flutter/material.dart';

class FeaturedArticleShimmer extends StatelessWidget {
  const FeaturedArticleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.opacityColor(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmer.rectangular(
            width: double.infinity,
            height: 200,
            borderRadius: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category and time shimmer
                Row(
                  children: [
                    const AppShimmer.rectangular(
                      width: 100,
                      height: 28,
                      borderRadius: 8,
                    ),
                    12.width,
                    const AppShimmer.rectangular(
                      width: 60,
                      height: 16,
                      borderRadius: 4,
                    ),
                  ],
                ),
                16.height,
                // Title shimmer
                const AppShimmer.rectangular(
                  width: double.infinity,
                  height: 24,
                  borderRadius: 4,
                ),
                8.height,
                const AppShimmer.rectangular(
                  width: 250,
                  height: 24,
                  borderRadius: 4,
                ),
                8.height,
                const AppShimmer.rectangular(
                  width: 200,
                  height: 24,
                  borderRadius: 4,
                ),
                12.height,
                // Subtitle shimmer
                const AppShimmer.rectangular(
                  width: double.infinity,
                  height: 18,
                  borderRadius: 4,
                ),
                8.height,
                const AppShimmer.rectangular(
                  width: double.infinity,
                  height: 18,
                  borderRadius: 4,
                ),
                8.height,
                const AppShimmer.rectangular(
                  width: 180,
                  height: 18,
                  borderRadius: 4,
                ),
                20.height,
                // Button shimmer
                const AppShimmer.rectangular(
                  width: double.infinity,
                  height: 48,
                  borderRadius: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

