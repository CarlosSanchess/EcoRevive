import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:register/Auth/Auth.dart';

import '../Pages/filterProduct.dart';


class FireStoreController{

   final db = FirebaseFirestore.instance;


  void addToProductsCollection(String productName, String description) async {
    // Create a new user with a first and last name
    final product = <String, dynamic> {
      "ProductName": productName,
      "Description": description,
      "Owner": await Auth().getUid()
    };

    db.collection("Products").add(product).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }

   Future<List<info>> fetchProductsByCategory(String category) async {
     User? user = FirebaseAuth.instance.currentUser;

     if (user != null) {
       QuerySnapshot categoryProducts = await db.collection('Products').where('Category', isEqualTo: category).get();
       List<info> products = [];
       for (QueryDocumentSnapshot doc in categoryProducts.docs) {
         String name = doc['ProductName'];
         String productCategory = doc['Category'];
         String description = doc['Description'];
         String productId = doc.id;

         String imageUrl = 'gs://vertical-prototype-70c6c.appspot.com/ProductImages%2F$productId?alt=media';

         products.add(info(productName: name, description: description, category: productCategory, imageURL: imageUrl));
       }
       return products;
     } else {
       throw 'Not logged in.';
     }
   }
}