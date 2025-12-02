import 'package:flutter/material.dart';

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
    // TODO: Thêm mới nguyên liệu với số lượng (quantity) do người dùng nhập
    String ingredientName = "";
    String quantity = "";

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Thêm nguyên liệu",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "Tên nguyên liệu",
                hintText: "Ví dụ: Thịt bò, Cà rốt...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => ingredientName = value,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: "Số lượng (tùy ý)",
                hintText: "Ví dụ: 200g, 1 củ, 1/2 chén...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => quantity = value,
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              final nameTrimmed = ingredientName.trim();
              final quantityTrimmed = quantity.trim();

              if (nameTrimmed.isEmpty) {
                Navigator.pop(context);
                return;
              }

              // TODO: Ghép tên + số lượng thành một chuỗi để giữ kiểu List<String>
              final displayText = quantityTrimmed.isNotEmpty
                  ? "$nameTrimmed - $quantityTrimmed"
                  : nameTrimmed;

              setState(() => ingredients.add(displayText));
              widget.onChange(ingredients); // Gọi onChange khi danh sách thay đổi
              Navigator.pop(context);
            },
            child: const Text("Thêm"),
          ),
        ],
      ),
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
            label: Text(item),
            onDeleted: () {
              setState(() => ingredients.remove(item));
              widget.onChange(ingredients); // Gọi onChange
            },
          ),
        ),
        ActionChip(
          label: const Text("Thêm nguyên liệu"),
          avatar: const Icon(Icons.add),
          onPressed: _addIngredient,
        ),
      ],
    );
  }
}
