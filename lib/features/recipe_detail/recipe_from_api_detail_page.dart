import 'package:flutter/material.dart';

import '../../commons/widgets/app/app_text.dart';
import '../../network/models/recipe_from_api_model.dart';

class RecipeFromApiDetailPage extends StatelessWidget {
  final RecipeFromApiModel recipe;

  const RecipeFromApiDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
        appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.pink),
        title: AppText.bold(
          recipe.name ?? '',
          fontSize: 18,
          color: Colors.pink.shade900,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade50,
              Colors.pink.shade100.withOpacity(0.3),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade100.withOpacity(0.6),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.menu_book_rounded,
                            color: Colors.pink.shade400,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppText.bold(
                            recipe.name ?? '',
                            fontSize: 20,
                            color: Colors.pink.shade900,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (recipe.ingredients != null && recipe.ingredients!.isNotEmpty) ...[
                AppText.bold(
                  'Nguyên liệu',
                  fontSize: 16,
                  color: Colors.pink.shade800,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: recipe.ingredients!
                        .map(
                          (ing) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 18,
                                  color: Colors.pink.shade300,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AppText.regular(
                                    '${ing.name}: ${ing.quantity}',
                                    fontSize: 14,
                                    color: Colors.grey.shade800,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (recipe.steps != null && recipe.steps!.isNotEmpty) ...[
                AppText.bold(
                  'Các bước thực hiện',
                  fontSize: 16,
                  color: Colors.pink.shade800,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: recipe.steps!
                        .asMap()
                        .entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.pink.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.pink.shade400,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AppText.regular(
                                    entry.value,
                                    fontSize: 14,
                                    maxLines: 5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (recipe.notes != null && recipe.notes!.isNotEmpty) ...[
                AppText.bold(
                  'Ghi chú',
                  fontSize: 16,
                  color: Colors.pink.shade800,
                  maxLines: 5,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: AppText.regular(
                    recipe.notes!,
                    fontSize: 14,
                    color: Colors.pink.shade700,
                    maxLines: 4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

