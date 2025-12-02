import 'package:flutter/material.dart';
import '../../network/models/recipe_model.dart';

class RecipeDetailPage extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name ?? '')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Nguyên liệu:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...recipe.ingredients!.map(
              (ing) => Text('${ing.name}: ${ing.quantity}'),
            ),
            const SizedBox(height: 20),
            Text('Các bước:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...recipe.steps!.map((step) => Text(step)),
            const SizedBox(height: 20),
            Text('Thời gian chuẩn bị: ${recipe.prepTime}'),
            Text('Thời gian nấu: ${recipe.cookTime}'),
            if (recipe.notes != null) Text('Ghi chú: ${recipe.notes}'),
          ],
        ),
      ),
    );
  }
}
