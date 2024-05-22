import 'package:flutter/material.dart';
import '../Controllers/FireStoreController.dart';
import '../Models/ProductInfo.dart';

class myProducts extends StatefulWidget{

  myProducts({Key? key}) : super(key: key);

  @override
  State<myProducts> createState() => _myProductsState();
}

class _myProductsState extends State<myProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
      ),
      body: FutureBuilder(
        future: FireStoreController().getOwnedProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<ProductInfo>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                ProductInfo product = snapshot.data![index];
                return Listing(product: product, onDelete: () {
                  setState(() {});
                });
              },
            );
          }
        },
      ),
    );
  }
}

class Listing extends StatelessWidget {
  final ProductInfo product;
  final VoidCallback onDelete;

  const Listing({required this.product, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(6.0),
      child: ListTile(
        leading: Image.network(
          product.imageURL,
          width: 80,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Text(product.productName),
        subtitle: Text(product.category),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            deleteProductOption(context, product, onDelete);
          },
        )
      ),
    );
  }
}

void deleteProductOption(BuildContext context, ProductInfo product, VoidCallback onDelete) async{
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.productName}?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              FireStoreController().deleteProduct(product);
              Navigator.of(context).pop();
              onDelete();
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}