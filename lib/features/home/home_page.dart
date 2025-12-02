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
      backgroundColor: Colors.pink[50],
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.pink.shade50,
                Colors.pink.shade50,
                Colors.pink.shade100.withOpacity(0.4),
              ],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  12.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nhee Cooking',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.pink.shade800,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                      Text(
                        'Gợi ý món ngon từ chính căn bếp của bạn ✨',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.pink.shade500,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              24.height,
              AppCard(
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        12.width,
                        Expanded(
                          child: Text(
                            "“Chỉ cần có nguyên liệu, món ngon luôn chờ bạn sáng tạo.”",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.pink.shade900,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                    20.height,
                    Text(
                      "Nguyên liệu bạn đang có",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.pink.shade700,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                    8.height,
                    IngredientSelector(
                      initialIngredients: const [],
                      onChange: (selected) {
                        controller.ingredients.value = selected.join(', ');
                      },
                    ),
                    20.height,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade400,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () async {
                          await controller.getMagicRecipe();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            8.width,
                            Text(
                              "Tạo công thức ngay",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              32.height,
              Text(
                "Gợi ý cho bạn",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.pink.shade800,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
              12.height,
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.recipes.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: 40,
                          color: Colors.pink.shade200,
                        ),
                        8.height,
                        Text(
                          'Chưa có công thức nào.\nHãy thêm nguyên liệu và bấm "Tạo công thức" nhé!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.pink.shade400,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.recipes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final recipe = controller.recipes[index];
                    return InkWell(
                      onTap: () {
                        Get.to(() => RecipeDetailPage(recipe: recipe));
                      },
                      child: RecipeItems(recipe: recipe),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
