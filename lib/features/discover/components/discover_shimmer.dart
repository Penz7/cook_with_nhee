import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:flutter/material.dart';

import '../../../commons/extensions/number_extension.dart';
import '../../../commons/widgets/app/app_shimmer.dart';

class DiscoverShimmerCard extends StatelessWidget {
  const DiscoverShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.opacityColor(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    const AppShimmer.rectangular(
                      width: 80,
                      height: 20,
                      borderRadius: 6,
                    ),
                    8.width,
                    const AppShimmer.circular(width: 4, height: 4),
                    8.width,
                    const AppShimmer.rectangular(
                      width: 50,
                      height: 14,
                      borderRadius: 4,
                    ),
                  ],
                ),
                12.height,
                // Title shimmer
                const AppShimmer.rectangular(
                  width: double.infinity,
                  height: 20,
                  borderRadius: 4,
                ),
                8.height,
                const AppShimmer.rectangular(
                  width: 200,
                  height: 20,
                  borderRadius: 4,
                ),
                8.height,
                const AppShimmer.rectangular(
                  width: double.infinity,
                  height: 16,
                  borderRadius: 4,
                ),
                4.height,
                const AppShimmer.rectangular(
                  width: 150,
                  height: 16,
                  borderRadius: 4,
                ),
              ],
            ),
          ),
          16.width,
          const AppShimmer.rectangular(
            width: 100,
            height: 100,
            borderRadius: 12,
          ),
        ],
      ),
    );
  }
}
