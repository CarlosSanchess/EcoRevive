import 'package:flutter/material.dart';

import '../Controllers/FireStoreController.dart';

class info {
  final String productName;
  final String description;
  final String category;
  final String imageURL;

  info({
    required this.productName,
    required this.description,
    required this.category,
    required this.imageURL,
  });
}


class ProductItem extends StatelessWidget {
  final info product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(
          product.imageURL,
          width: 100, // adjust width as needed
          height: 100, // adjust height as needed
          fit: BoxFit.cover, // adjust the fit as needed
        ),
        title: Text(product.productName),
        subtitle: Text('Category: ${product.category}'),
        // Add more details as needed
      ),
    );
  }
}






class filterProduct extends StatefulWidget {
  const filterProduct({super.key});

  @override
  _filterProductState createState() => _filterProductState();
}

class _filterProductState extends State<filterProduct> {
  bool isChecked = false;
  bool isConditionExpanded = false;
  String? selectedCategory;
  List<info>? products;


  void onCategorySelected(String category) {
    setState(() {
      if (selectedCategory == category) {
        selectedCategory = null;
        FireStoreController().fetchProductsByCategory("all").then((fetchedProducts) {
          setState(() {
            products = fetchedProducts;
          });
        });
      } else {
        selectedCategory = category;
        FireStoreController().fetchProductsByCategory(category).then((fetchedProducts) {
          setState(() {
            products = fetchedProducts;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
                        prefixIcon: const Icon(Icons.search, size: 16,),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: const Icon(Icons.search),

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
                  filterChip(
                    'Computador',
                    selectedCategory == 'Computador',
                    Theme.of(context).brightness == Brightness.light ? Colors.lightGreenAccent : Color.fromRGBO(94, 39, 176, 1.0),
                    Colors.grey[300]!,
                    onCategorySelected,
                  ),
                  filterChip(
                    'Telemóvel',
                    selectedCategory == 'Telemóvel',
                    Theme.of(context).brightness == Brightness.light ? Colors.lightGreenAccent : Color.fromRGBO(94, 39, 176, 1.0),
                    Colors.grey[300]!,
                    onCategorySelected,
                  ),
                  filterChip(
                    'Teclado',
                    selectedCategory == 'Teclado',
                    Theme.of(context).brightness == Brightness.light ? Colors.lightGreenAccent : Color.fromRGBO(94, 39, 176, 1.0),
                    Colors.grey[300]!,
                    onCategorySelected,
                  ),
                  filterChip(
                    'Rato',
                    selectedCategory == 'Rato',
                    Theme.of(context).brightness == Brightness.light ? Colors.lightGreenAccent : Color.fromRGBO(94, 39, 176, 1.0),
                    Colors.grey[300]!,
                    onCategorySelected,
                  ),
                  filterChip(
                    'Outro',
                    selectedCategory == 'Outro',
                    Theme.of(context).brightness == Brightness.light ? Colors.lightGreenAccent : Color.fromRGBO(94, 39, 176, 1.0),
                    Colors.grey[300]!,
                    onCategorySelected,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            if (products != null && products!.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: products!.length,
                  itemBuilder: (context, index) {
                    final product = products![index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(product.imageURL),
                        title: Text(product.productName),
                        subtitle: Text(product.description),
                      ),
                    );
                  },
                ),
              ),
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
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        selected: isSelected,
        selectedColor: selectedColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.grey[300] : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: unselectedColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: isSelected ? Color.fromRGBO(94, 39, 176, 1.0) : unselectedColor,
            width: 1.5,
          ),
        ),
        checkmarkColor: Colors.grey[300],
        onSelected: (value) {
          onCategorySelected(label);
        },
      ),
    );
  }
}