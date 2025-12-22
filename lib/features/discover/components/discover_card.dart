import 'package:cook_with_nhee/commons/extensions/color_extension.dart';
import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/font_sizes.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_image.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:flutter/material.dart';

class DiscoverCard extends StatelessWidget {
  const DiscoverCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.timeAgo,
    required this.imageUrl,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String category;
  final String timeAgo;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                      Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).opacityColor(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: AppText.bold(
                          textAlign: TextAlign.center,
                          category.toUpperCase(),
                          fontSize: 10,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                      8.width,
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      8.width,
                      AppText.regular(
                        timeAgo,
                        fontSize: FontSizes.extraSmall,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                  12.height,
                  AppText.bold(title, fontSize: FontSizes.small, maxLines: 3),
                  8.height,
                  AppText.regular(
                    subtitle,
                    fontSize: FontSizes.moreSmall,
                    color: Colors.grey.shade700,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            16.width,
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 100,
                height: 100,
                child: AppInternetImage(
                  url: imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
