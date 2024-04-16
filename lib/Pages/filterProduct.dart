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
        title: Row(
          children: [
            Image.asset('lib/Imgs/Icon.png', height: 40,),
            const SizedBox(width: 10),
            const Text(
              'EcoRevive',
              style: TextStyle(color: Colors.black),
            ),
          ],
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
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: Icon(Icons.search),

                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Category',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  filterChip('Electronics', selectedCategory == 'Electronics',
                      Colors.lightGreenAccent, Colors.grey[300]!, onCategorySelected),
                  filterChip('Furniture', selectedCategory == 'Furniture',
                      Colors.lightGreenAccent, Colors.grey[300]!, onCategorySelected),
                  filterChip(
                      'Clothing', selectedCategory == 'Clothing', Colors.lightGreenAccent,
                      Colors.grey[300]!, onCategorySelected),
                  filterChip(
                      'Books', selectedCategory == 'Books', Colors.lightGreenAccent,
                      Colors.grey[300]!, onCategorySelected),
                  filterChip(
                      'Others', selectedCategory == 'Others', Colors.lightGreenAccent,
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
        label: Text(
          label,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        selected: isSelected,
        selectedColor: selectedColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.green : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: unselectedColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: isSelected ? Colors.green : unselectedColor,
            width: 1.5,
          ),
        ),
        checkmarkColor: Colors.green,
        onSelected: (value) {
          onCategorySelected(label);
        },
      ),
    );
  }
}