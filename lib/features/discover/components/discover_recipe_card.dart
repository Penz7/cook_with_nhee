import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_image.dart';
import 'package:flutter/material.dart';

class DiscoverRecipeCard extends StatelessWidget {
  const DiscoverRecipeCard({
    super.key,
    required this.title,
    required this.calories,
    required this.duration,
    required this.imageUrl,
    this.isFavorite = false,
    this.isSaving = false,
    this.onTap,
    this.onToggleFavorite,
    this.customActionIcon,
  });

  final String title;
  final String calories;
  final String duration;
  final String imageUrl;
  final bool isFavorite;
  final bool isSaving;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFavorite;
  final IconData? customActionIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: UIColors.creamy,
                    ),
                    child: AppInternetImage(
                      url: imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      isFood: true,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: _FavoriteButton(
                  isFavorite: isFavorite,
                  isSaving: isSaving,
                  onPressed: onToggleFavorite,
                  customIcon: customActionIcon,
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    calories,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: UIColors.pink,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 14,
                color: Colors.grey.shade700,
              ),
              const SizedBox(width: 6),
              Text(
                duration,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.isFavorite,
    required this.isSaving,
    this.onPressed,
    this.customIcon,
  });

  final bool isFavorite;
  final bool isSaving;
  final VoidCallback? onPressed;
  final IconData? customIcon;

  @override
  Widget build(BuildContext context) {
    final iconColor = isFavorite ? UIColors.pink : Colors.white;
    final backgroundColor = isFavorite ? Colors.white : Colors.white.withOpacity(0.35);

    return GestureDetector(
      onTap: isSaving ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(UIColors.pink),
                  ),
                )
              : Icon(
                  customIcon ?? (isFavorite ? Icons.favorite : Icons.favorite_border),
                  size: 20,
                  color: customIcon != null ? UIColors.pink : iconColor,
                ),
        ),
      ),
    );
  }
}

