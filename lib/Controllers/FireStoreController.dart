import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:register/Auth/Auth.dart';


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
}