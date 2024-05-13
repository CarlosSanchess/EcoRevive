import 'package:flutter/material.dart';
import 'package:register/API/API.dart';
import 'package:register/Controllers/FireStoreController.dart';
class UserController {
  final String userID;

  const UserController({
    required this.userID,
  });

 void deleteUser(){
    FireStoreController().removeAssociatedProducts(userID);
    FireStoreController().removeUser(userID);
    API().banUser(userID);
 }
}
