import 'package:flutter/material.dart';
import '../Controllers/FireStoreController.dart';
import 'package:register/Models/ProductInfo.dart';
import 'package:register/Pages/Product.dart';

class ProductItem extends StatelessWidget {
  final ProductInfo product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return  GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductPage(product: product)),);
      },
      child: Card(
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

  TextEditingController searchController = TextEditingController();

  Widget buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search for your item...',
              hintStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 16,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey,
              ),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? Color.fromRGBO(42, 41, 58, 1.0) : Colors.grey[200],
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
          onPressed: () async {
            try {
              List<ProductInfo> fetchedProducts = await FireStoreController().fetchProductsBySearchTerm(
                  searchController.text,
                  selectedCategory!
              );
              setState(() {
                products = fetchedProducts;
              });
            } catch (error) {
              print("Error fetching products: $error");
            }
          },
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
        label: Text(label, style: TextStyle(fontSize: 18, color: isSelected ?  Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.white : Colors.grey[400])),
        selected: isSelected,
        selectedColor: selectedColor,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Color.fromRGBO(42, 41, 58, 1.0) : Colors.grey[300]!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: isSelected
              ? Theme.of(context).brightness == Brightness.dark
              ? Colors.white : Colors.green
              : Theme.of(context).brightness == Brightness.dark
              ? Color.fromRGBO(42, 41, 58, 1.0) : Colors.white
              , width: 1.5),
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
