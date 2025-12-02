import 'package:flutter/material.dart';

class IngredientSelector extends StatefulWidget {
  final List<String> initialIngredients;
  final Function(List<String>) onChange; // Thêm callback

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
    String text = "";

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Thêm nguyên liệu"),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Enter ingredient name",
          ),
          onChanged: (value) => text = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (text.trim().isNotEmpty) {
                setState(() => ingredients.add(text.trim()));
                widget.onChange(ingredients); // Gọi onChange
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
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
