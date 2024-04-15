import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  _CategorySelectionWidgetState createState() => _CategorySelectionWidgetState();

  String? getCategory() {
    return _CategorySelectionWidgetState.selectedCategory;
  }

  void resetCategory() {
    _CategorySelectionWidgetState.resetState();
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton<String>(
        value: selectedCategory,
        focusColor: Colors.green,
        onChanged: (String? newValue) {
          setState(() {
            selectedCategory = newValue; // Assign newValue to static variable
          });
        },
        underline: Container(),
        icon: const Icon(Icons.arrow_drop_down_sharp),
        iconSize: 24,
        isExpanded: true,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        items: _categories.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }
}
