import 'package:flutter/material.dart';

class filterProduct extends StatefulWidget {
  const filterProduct({Key? key}) : super(key: key);

  @override
  _filterProductState createState() => _filterProductState();
}

class _filterProductState extends State<filterProduct> {
  bool isChecked = false;
  bool isConditionExpanded = false;
  String? selectedCategory;

  void onCategorySelected(String category) {
    setState(() {
      if (selectedCategory == category) {
        selectedCategory = null;
      } else {
        selectedCategory = category;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Filter',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for your item...',
                        prefixIcon: Icon(Icons.search, size: 16,),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                    )
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Category',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  filterChip('Electronics', selectedCategory == 'Electronics',
                      Colors.purple, Colors.grey[300]!, onCategorySelected),
                  filterChip('Furniture', selectedCategory == 'Furniture',
                      Colors.purple, Colors.grey[300]!, onCategorySelected),
                  filterChip(
                      'Clothing', selectedCategory == 'Clothing', Colors.purple,
                      Colors.grey[300]!, onCategorySelected),
                  filterChip(
                      'Books', selectedCategory == 'Books', Colors.purple,
                      Colors.grey[300]!, onCategorySelected),
                  filterChip(
                      'Others', selectedCategory == 'Others', Colors.purple,
                      Colors.grey[300]!, onCategorySelected),
                ],
              ),
            ),
            const SizedBox(height: 20),
            /*InkWell(
              onTap: () {
                setState(() {
                  isConditionExpanded = !isConditionExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Other Filters',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Icon(
                    isConditionExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            if (isConditionExpanded)
              Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Condition',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //filterChip('New', false),
                      //filterChip('Used', false),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      const Text(
                        'Only show items with images',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),*/
          ],
        ),
      ),
    );
  }

  Widget filterChip(String label, bool isSelected, Color selectedColor,
      Color unselectedColor, Function(String) onCategorySelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: selectedColor,
        labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black, // Use black color for unselected chips
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
        backgroundColor: unselectedColor,
        onSelected: (value) {
          onCategorySelected(label);
        },
        shape: StadiumBorder(
          side: BorderSide(
            color: isSelected ? selectedColor : Colors.grey[600]!,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
