import 'package:flutter/material.dart';
import '../Controllers/FireStoreController.dart';

class ProductInfo {
  final String productName;
  final String description;
  final String category;
  final String imageURL;

  ProductInfo({
    required this.productName,
    required this.description,
    required this.category,
    required this.imageURL,
  });
}

class ProductItem extends StatelessWidget {
  final ProductInfo product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(
          product.imageURL,
          width: 60,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Text(product.productName),
        subtitle: Text('Category: ${product.category}'),
      ),
    );
  }
}

class FilterProduct extends StatefulWidget {
  const FilterProduct({Key? key}) : super(key: key);

  @override
  _FilterProductState createState() => _FilterProductState();
}

class _FilterProductState extends State<FilterProduct> {
  String? selectedCategory;
  List<ProductInfo>? products;

  @override
  void initState() {
    super.initState();
    onCategorySelected("all");
  }

  void onCategorySelected(String category) {
    FireStoreController().fetchProductsByCategory(category).then((fetchedProducts) {
      setState(() {
        products = fetchedProducts;
        selectedCategory = category;
      });
    }).catchError((error) {
      // Handle errors here, e.g., show a snackbar or alert dialog
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
            buildSearchRow(),
            const SizedBox(height: 20),
            const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            const SizedBox(height: 10),
            buildCategoryChips(),
            const SizedBox(height: 20),
            buildProductList(),
          ],
        ),
      ),
    );
  }

  Widget buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for your item...',
              prefixIcon: const Icon(Icons.search, size: 16),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: const Icon(Icons.search),
        ),
      ],
    );
  }

  Widget buildCategoryChips() {
    List<String> categories = ['all', 'Computador', 'Telemóvel', 'Teclado', 'Rato', 'Outro'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) => filterChip(category)).toList(),
      ),
    );
  }

  Widget filterChip(String label) {
    bool isSelected = selectedCategory == label;
    Color selectedColor = Theme.of(context).brightness == Brightness.light ? Colors.green : Color.fromRGBO(94, 39, 176, 1.0);
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 18, color: isSelected ? Colors.white : Colors.black)),
        selected: isSelected,
        selectedColor: selectedColor,
        backgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: isSelected ? selectedColor : Colors.grey[300]!, width: 1.5),
        ),
        checkmarkColor: Colors.white,
        onSelected: (bool value) {
          onCategorySelected(label);
        },
      ),
    );
  }

  Widget buildProductList() {
    if (products == null || products!.isEmpty) {
      return Expanded(child: Center(child: Text('No products found')));
    }
    return Expanded(
      child: ListView.builder(
        itemCount: products!.length,
        itemBuilder: (context, index) {
          final product = products![index];
          return ProductItem(product: product);
        },
      ),
    );
  }
}
