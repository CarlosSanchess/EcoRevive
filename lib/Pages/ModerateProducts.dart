import 'package:flutter/material.dart';
import 'package:register/Pages/ModeratorHome.dart';
import '../Controllers/FireStoreController.dart';
import '../Models/ProductInfo.dart';
import '../Pages/myProducts.dart';

class ModerateProducts extends StatefulWidget {
  final String category;

  const ModerateProducts({Key? key, required this.category}) : super(key: key);

  @override
  State<ModerateProducts> createState() => _ModerateProductsState();
}

class _ModerateProductsState extends State<ModerateProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ModeratorHome()),
            );
          },
        ),
        title: Text(widget.category == 'suspicious' ? 'Suspicious Products' : 'Products'),
      ),
      body: widget.category == 'suspicious'
          ? SuspiciousProducts()
          : ModerateProductsList(),
    );
  }
}

class SuspiciousProducts extends StatefulWidget {
  @override
  State<SuspiciousProducts> createState() => _SuspiciousProductsState();
}

class _SuspiciousProductsState extends State<SuspiciousProducts> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FireStoreController().fetchSuspiciousProducts(),
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
    );
  }
}

class ModerateProductsList extends StatefulWidget {
  @override
  State<ModerateProductsList> createState() => _ModerateProductsListState();
}

class _ModerateProductsListState extends State<ModerateProductsList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FireStoreController().fetchProductsAll(),
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
              FireStoreController().deleteProductModerate(product);
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

