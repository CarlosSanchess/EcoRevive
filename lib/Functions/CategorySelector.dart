import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  _CategorySelectionWidgetState createState() => _CategorySelectionWidgetState();

  String? getCategory() {
    return _CategorySelectionWidgetState.selectedCategory;
  }

  void resetCategory() {
    _CategorySelectionWidgetState().resetCategory();
  }
}

class _CategorySelectionWidgetState extends State<CategorySelector> {
  static String? selectedCategory;

  final List<String> _categories = [
    'Rato',
    'Teclado',
    'Computador',
    'Telemóvel',
    'Outro'
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[950] : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: PopupMenuButton<String>(
        initialValue: selectedCategory,
        onSelected: (String? newValue) {
          setState(() {
            selectedCategory = newValue;
          });
        },
        itemBuilder: (BuildContext context) {
          return _categories.map((String category) {
            return PopupMenuItem<String>(
              value: category,
              child: Text(
                category,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            );
          }).toList();
        },
        offset: const Offset(0, 40),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: backgroundColor,
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  selectedCategory ?? 'Select Category',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_down_sharp),
            ],
          ),
        ),
      ),
    );
  }

  void resetCategory() {
    setState(() {
      selectedCategory = null;
    });
  }
}
