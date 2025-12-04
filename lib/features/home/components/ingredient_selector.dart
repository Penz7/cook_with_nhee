import 'package:flutter/material.dart';

import '../../../commons/extensions/color_extension.dart';
import '../../../commons/extensions/number_extension.dart';
import '../../../commons/widgets/app/app_text.dart';

class IngredientSelector extends StatefulWidget {
  final List<String> initialIngredients;
  final Function(List<String>) onChange;

  const IngredientSelector({
    super.key,
    this.initialIngredients = const [],
    required this.onChange,
  });

  @override
  State<IngredientSelector> createState() => _IngredientSelectorState();
}

class _IngredientSelectorState extends State<IngredientSelector> {
  late List<String> ingredients;

  @override
  void initState() {
    super.initState();
    ingredients = List.from(widget.initialIngredients);
  }

  void _addIngredient() async {
    String ingredientName = "";
    String quantity = "";

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: double.maxFinite,
            constraints: const BoxConstraints(
              maxWidth: 480, // dialog rộng hơn một chút cho phần hướng dẫn
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.shade100.opacityColor(0.6),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.pink.shade400,
                          size: 20,
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.bold(
                              "Thêm nguyên liệu",
                              fontSize: 16,
                              color: Colors.pink.shade900,
                            ),
                            4.height,
                            AppText.regular(
                              "Nhập tên nguyên liệu và số lượng (nếu cần). Mỗi lần thêm một nguyên liệu.",
                              fontSize: 12,
                              maxLines: 5,
                              color: Colors.pink.shade400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  16.height,
                  TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: "Tên nguyên liệu",
                      hintText: "Ví dụ: Thịt bò, Cà rốt, Hành tây...",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => ingredientName = value,
                  ),
                  12.height,
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Số lượng (tùy ý)",
                      hintText: "Ví dụ: 200g, 1 củ, 1/2 chén...",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => quantity = value,
                  ),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: AppText.regular(
                          "Hủy",
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      8.width,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade400,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 1,
                        ),
                        onPressed: () {
                          final nameTrimmed = ingredientName.trim();
                          final quantityTrimmed = quantity.trim();

                          if (nameTrimmed.isEmpty) {
                            Navigator.pop(context);
                            return;
                          }

                          // Không cho phép thêm trùng nếu chỉ cần 1 từ giống (so sánh theo từng từ, bỏ phần số lượng nếu có)
                          final newWords = nameTrimmed
                              .toLowerCase()
                              .split(RegExp(r'\\s+'))
                              .where((w) => w.isNotEmpty)
                              .toSet();

                          final exists = ingredients.any((item) {
                            final base = item
                                .split('-')
                                .first
                                .trim()
                                .toLowerCase();
                            final baseWords = base
                                .split(RegExp(r'\\s+'))
                                .where((w) => w.isNotEmpty)
                                .toSet();
                            // Nếu có ít nhất 1 từ giao nhau thì xem như trùng
                            return newWords.intersection(baseWords).isNotEmpty;
                          });
                          if (exists) {
                            Navigator.pop(context);
                            return;
                          }

                          final displayText = quantityTrimmed.isNotEmpty
                              ? "$nameTrimmed - $quantityTrimmed"
                              : nameTrimmed;
                          setState(() => ingredients.add(displayText));

                          widget.onChange(ingredients); // Gọi onChange khi danh sách thay đổi
                          Navigator.pop(context);
                        },
                        child: AppText.semiBold(
                          "Thêm",
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...ingredients.map(
          (item) => InputChip(
            label: AppText.regular(item),
            onDeleted: () {
              setState(() => ingredients.remove(item));
              widget.onChange(ingredients); // Gọi onChange
            },
          ),
        ),
        ActionChip(
          label: AppText.regular("Thêm nguyên liệu"),
          avatar: const Icon(Icons.add),
          onPressed: _addIngredient,
        ),
      ],
    );
  }
}
