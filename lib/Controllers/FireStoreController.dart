import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:register/Auth/Auth.dart';


class FireStoreController{

   final db = FirebaseFirestore.instance;


  void addToProductsCollection(String productName, String description, String? category) async {
    // Create a new user with a first and last name
    final product = <String, dynamic> {
      "ProductName": productName,
      "Description": description,
      "Category": category,
      "Owner": await Auth().getUid()
    };

    db.collection("Products").add(product).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }

}