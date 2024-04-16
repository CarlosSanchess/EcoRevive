import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:register/Auth/Auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


import '../Pages/filterProduct.dart';


class FireStoreController{

   final db = FirebaseFirestore.instance;
   final storage = FirebaseStorage.instance;


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

   Future<List<info>> fetchProductsByCategory(String category) async {
     User? user = FirebaseAuth.instance.currentUser;

     if (user != null) {
       QuerySnapshot categoryProducts;
       if (category == "all") {
         categoryProducts = await db.collection('Products').get();
       } else {
         categoryProducts = await db.collection('Products').where('Category', isEqualTo: category).get();
       }
       List<info> products = [];
       for (QueryDocumentSnapshot doc in categoryProducts.docs) {
         String name = doc['ProductName'];
         String productCategory = doc['Category'];
         String description = doc['Description'];
         String productId = doc.id;

         Reference imageRef = storage.ref().child('ProductImages/$productId');
         String imageUrl = await imageRef.getDownloadURL();
         products.add(info(productName: name, description: description, category: productCategory, imageURL: imageUrl));
       }
       return products;
     } else {
       throw 'Not logged in.';
     }
   }
}