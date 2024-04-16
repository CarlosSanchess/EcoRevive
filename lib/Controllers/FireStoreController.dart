import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:register/Auth/Auth.dart';
import 'package:register/Controllers/CloudStorageController.dart';



import '../Pages/filterProduct.dart';
import '../Pages/myProducts.dart';
import '../Pages/filterProduct.dart' as filter;

class FireStoreController{

  final db = FirebaseFirestore.instance;


  Future<String> addToProductsCollection(String productName, String description, String? category) async {

    // Create a new user with a first and last name
    final product = <String, dynamic>{
      "ProductName": productName,
      "Description": description,
      "Category": category,
      "Owner": await Auth().getUid()
    };

    final DocumentReference docRef = await db.collection("Products").add(
        product);
    return docRef.id;
  }


  Future<List<info>> getOwnedProducts() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot ownedProducts = await db.collection('Products').where('Owner', isEqualTo: user.uid).get();
      List<info> products = [];
      for (QueryDocumentSnapshot doc in ownedProducts.docs) {
        String name = doc['ProductName'];
        String category = doc['Category'];
        String description = doc['Description'];
        String productId = doc.id;

        String imageUrl = await CloudStorageController().getDownloadURL('ProductImages/$productId');

        products.add(info(productID: productId, productName: name, description: description, category: category, imageURL: imageUrl));
      }
      return products;
    } else {
      throw 'Not logged in.';
    }
  }


  Future<void> deleteProduct(info product) async {
    try {
      CloudStorageController().deleteImage('ProductImages/${product.productID}');
      DocumentReference productRef = FirebaseFirestore.instance.collection('Products').doc(product.productID);
      await productRef.delete();

    } catch (error) {
      print("Error while deleting: $error");
    }
  }

  Future<List<ProductInfo>> fetchProductsByCategory(String category) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot categoryProducts;
      if (category == "all") {
        categoryProducts = await db.collection('Products').get();
      } else {
        categoryProducts = await db.collection('Products').where('Category', isEqualTo: category).get();
      }
      List<ProductInfo> products = [];
      for (QueryDocumentSnapshot doc in categoryProducts.docs) {
        String name = doc['ProductName'];
        String productCategory = doc['Category'];
        String description = doc['Description'];
        String productId = doc.id;

        String imageUrl = await CloudStorageController().getDownloadURL('ProductImages/$productId');
        products.add(filter.ProductInfo(productName: name, description: description, category: productCategory, imageURL: imageUrl));
      }
      return products;
    } else {
      throw 'Not logged in.';
    }
  }

}