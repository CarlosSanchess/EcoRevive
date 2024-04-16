import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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


class categoryProducts extends StatefulWidget{

  categoryProducts({Key? key}) : super(key: key);

  @override
  State<categoryProducts> createState() => _categoryProductsState();
}

class _categoryProductsState extends State<categoryProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
      ),
      body: FutureBuilder(
        future: FireStoreController().fetchProductsByCategory("all"),
        builder: (BuildContext context, AsyncSnapshot<List<info>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                info product = snapshot.data![index];
                return ProductItem(product: product);
              },
            );
          }
        },
      ),
    );
  }
}
class ProductItem extends StatelessWidget {
  final info product;

  const ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
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
  const filterProduct({Key? key}) : super(key: key);

  @override
  _filterProductState createState() => _filterProductState();
}

class _filterProductState extends State<filterProduct> {
  bool isChecked = false;
  bool isConditionExpanded = false;
  String? selectedCategory;
  List<info>? products;

  Future<void> fetchProductsByCategory(String category) async {
    QuerySnapshot querySnapshot;
    if (category == "all") {
      querySnapshot = await FirebaseFirestore.instance.collection('Products').get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .where('Category', isEqualTo: category)
          .get();
    }

    setState(() {
      products = querySnapshot.docs.map((doc) {
        return info(
          productName: doc['ProductName'],
          description: doc['Description'],
          category: doc['Category'],
          imageURL: doc['ImageURL'],
        );
      }).toList();
    });
  }

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
                  filterChip('Computador', selectedCategory == 'Computador',
                      Colors.lightGreenAccent, Colors.grey[300]!, onCategorySelected),
                  filterChip('Telemóvel', selectedCategory == 'Telemóvel',
                      Colors.lightGreenAccent, Colors.grey[300]!, onCategorySelected),
                  filterChip('Teclado', selectedCategory == 'Teclado',
                      Colors.lightGreenAccent, Colors.grey[300]!, onCategorySelected),
                  filterChip('Rato', selectedCategory == 'Rato',
                      Colors.lightGreenAccent, Colors.grey[300]!, onCategorySelected),
                  filterChip('Outro', selectedCategory == 'Outro',
                      Colors.lightGreenAccent, Colors.grey[300]!, onCategorySelected),
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