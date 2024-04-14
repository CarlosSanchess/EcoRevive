import 'package:cloud_firestore/cloud_firestore.dart';


class FireStoreController{

   final db = FirebaseFirestore.instance;


  void addToDataBase(String productName, String description ){
    // Create a new user with a first and last name
    final product = <String, dynamic>{
      "ProductName": productName,
      "Description": description,
    };

    db.collection("Users").add(product).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }

}