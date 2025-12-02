import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../commons/extensions/number_extension.dart';
import '../../commons/style/colors.dart';
import '../../commons/widgets/card/app_card.dart';
import '../../commons/widgets/items/recipe_items.dart';
import '../../env.dart';
import '../../network/constants/prompt.dart';
import '../../network/provider/api_client.dart';
import '../recipe_detail/recipe_detail_page.dart';
import 'components/ingredient_selector.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(Get.find(), Get.find<ApiClient>()));
  }
}

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: UIColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'AI Recipe',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins.toString(),
                ),
              ),
              20.height,
              AppCard(
                body: Column(
                  mainAxisSize: .min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.create,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                        12.width,
                        Expanded(
                          child: Text(
                            "“Chỉ cần có nguyên liệu, món ngon luôn chờ bạn sáng tạo.”",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.poppins.toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    20.height,
                    IngredientSelector(
                      initialIngredients: [],
                      onChange: (selected) {
                        controller.ingredients.value = selected.join(', ');
                      },
                    ),
                    20.height,
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black),
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 20),
                        ),
                      ),
                      onPressed: () async {
                        await controller.getMagicRecipe();
                      },
                      child: Row(
                        mainAxisAlignment: .center,
                        children: [
                          Icon(Icons.create, color: Colors.white, size: 20),
                          12.width,
                          Text(
                            "Tạo công thức",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.poppins.toString(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              40.height,
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.recipes.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Chưa có công thức nào'),
                  );
                }
                return Expanded(
                  child: ListView.separated(
                    itemCount: controller.recipes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final recipe = controller.recipes[index];
                      return InkWell(
                        onTap: () {
                          Get.to(() => RecipeDetailPage(recipe: recipe));
                        },
                        child: RecipeItems(recipe: recipe),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
