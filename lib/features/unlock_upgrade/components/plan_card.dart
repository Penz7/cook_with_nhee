import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.oldPrice,
    required this.features,
    required this.isPro,
    required this.onSelect,
    this.onStartTrial,
    this.trialSubtext,
  });

  final String title;
  final String subtitle;
  final String price;
  final String? oldPrice;
  final List<PlanFeature> features;
  final bool isPro;
  final VoidCallback onSelect;
  final VoidCallback? onStartTrial;
  final String? trialSubtext;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isPro ? 0 : 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPro ? UIColors.pink : Colors.blue.shade200,
          width: isPro ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isPro ? UIColors.pink : Colors.blue.shade200)
                .withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPro)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: UIColors.pink,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'MOST POPULAR',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          if (isPro) 12.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  if (isPro) ...[
                    8.width,
                    const Icon(
                      Icons.star,
                      color: UIColors.pink,
                      size: 20,
                    ),
                  ],
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  if (oldPrice != null) ...[
                    2.height,
                    Text(
                      oldPrice!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          8.height,
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isPro ? UIColors.pink : Colors.blue.shade400,
            ),
          ),
          20.height,
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      feature.isLocked
                          ? Icons.lock_outline
                          : Icons.check_circle,
                      color: feature.isLocked
                          ? Colors.grey.shade400
                          : (isPro ? UIColors.pink : Colors.blue.shade400),
                      size: 20,
                    ),
                    12.width,
                    Expanded(
                      child: Text(
                        feature.text,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: feature.isLocked
                              ? Colors.grey.shade500
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          if (isPro && onStartTrial != null) ...[
            24.height,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onStartTrial,
                style: ElevatedButton.styleFrom(
                  backgroundColor: UIColors.pink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Column(
                  children: [
                    const Text(
                      'Start 7-Day Free Trial',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (trialSubtext != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        trialSubtext!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PlanFeature {
  PlanFeature({
    required this.text,
    this.isLocked = false,
  });

  final String text;
  final bool isLocked;
}

