import 'recipe_from_api_model.dart';
import 'recipe_from_api_model.dart' as api_model;
import 'recipe_model.dart';

/// Extension để convert RecipeModel (từ AI) sang RecipeFromApiModel (cho API backend)
extension RecipeModelExtension on RecipeModel {
  /// Convert RecipeModel sang RecipeFromApiModel để lưu vào backend
  RecipeFromApiModel toRecipeFromApiModel() {
    // Convert images và videos từ dynamic sang List<String>
    List<String> imagesList = [];
    if (images != null) {
      imagesList = images!
          .where((item) => item is String)
          .map((item) => item as String)
          .toList();
    }

    List<String> videosList = [];
    if (videos != null) {
      videosList = videos!
          .where((item) => item is String)
          .map((item) => item as String)
          .toList();
    }

    // Convert Ingredients từ RecipeModel sang RecipeFromApiModel
    List<api_model.Ingredients>? ingredientsList;
    if (ingredients != null) {
      ingredientsList = ingredients!
          .map((ing) => api_model.Ingredients(
                id: ing.id,
                name: ing.name,
                quantity: ing.quantity,
              ))
          .toList();
    }

    // Convert Tags từ RecipeModel sang RecipeFromApiModel
    List<api_model.Tags>? tagsList;
    if (tags != null) {
      tagsList = tags!
          .map((tag) => api_model.Tags(
                id: tag.id,
                name: tag.name,
              ))
          .toList();
    }

    return RecipeFromApiModel(
      name: name,
      description: description,
      ingredients: ingredientsList,
      tags: tagsList,
      steps: steps,
      notes: notes,
      images: imagesList.isNotEmpty ? imagesList : null,
      videos: videosList.isNotEmpty ? videosList : null,
      // Không set id, created_at, updated_at, created_by vì sẽ được backend tự động tạo
    );
  }
}

