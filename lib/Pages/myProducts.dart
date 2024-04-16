import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Controllers/FireStoreController.dart';

class info{
  final String productName;
  final String description;
  final String category;
  final String imageURL;

  info({
    required this.productName,
    required this.description,
    required this.category,
    required this.imageURL
  });
}

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
                return Listing(product: product);
              },
            );
          }
        },
      ),
    );
  }
}

class Listing extends StatelessWidget {
  final info product;

  const Listing({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(
          product.imageURL,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Text(product.productName),
        subtitle: Text('Category: ${product.category}'),
      ),
    );
  }
}
