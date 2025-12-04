import 'package:cook_with_nhee/commons/extensions/number_extension.dart';
import 'package:cook_with_nhee/commons/widgets/app/primary_scaffold.dart';
import 'package:cook_with_nhee/commons/widgets/app/app_text.dart';
import 'package:cook_with_nhee/commons/widgets/items/recipe_from_api_items.dart';
import 'package:cook_with_nhee/commons/widgets/loading/recipe_loading_shimmer.dart';
import 'package:cook_with_nhee/features/my_recipes/my_recipes_controller.dart';
import 'package:cook_with_nhee/features/recipe_detail/recipe_from_api_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/provider/api_client.dart';

class MyRecipesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyRecipesController(Get.find<ApiClient>()));
  }
}

class MyRecipesPage extends GetView<MyRecipesController> {
  const MyRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.pink.shade900),
        title: AppText.bold(
          'Công thức của tôi',
          fontSize: 20,
          color: Colors.pink.shade900,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshRecipes,
        color: Colors.pink.shade400,
        child: Obx(() {
          if (controller.isLoading.value) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: const RecipeLoadingShimmer(itemCount: 5),
            );
          }
          if (controller.recipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 80,
                    color: Colors.pink.shade200,
                  ),
                  20.height,
                  AppText.regular(
                    'Chưa có công thức nào.\nHãy lưu công thức từ trang chủ nhé!',
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    color: Colors.pink.shade400,
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: controller.recipes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final recipe = controller.recipes[index];
              return InkWell(
                onTap: () {
                  Get.to(() => RecipeFromApiDetailPage(recipe: recipe));
                },
                child: RecipeFromApiItems(recipe: recipe),
              );
            },
          );
        }),
      ),
    );
  }
}
