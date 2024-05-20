import 'package:flutter/material.dart';
import 'package:register/API/API.dart';
import 'package:register/Controllers/FireStoreController.dart';

import '../Models/UsersInfo.dart';

class UserController {
  final UsersInfo userInfo;

  const UserController({
    required this.userInfo,
  });

 void deleteUser(){
    FireStoreController().removeAssociatedProducts(userInfo.userID);
    FireStoreController().removeUser(userInfo.userID);
    API().banUser(userInfo.userID);
 }
 void enableUser(){
   API().enableUser(userInfo.userID);
   FireStoreController().removeFromDisableCollection(userInfo.userID);
   FireStoreController().addToUsersCollection(userInfo);
 }
  void disableUser(){
    API().disableUser(userInfo.userID);
    FireStoreController().addToDisableCollection(userInfo);
  }
}
