import 'package:flutter/material.dart';
import 'package:register/Controllers/FireStoreController.dart';
import 'package:register/Controllers/CloudStorageController.dart';
import 'dart:io' as io;

class AddProductController {
  final TextEditingController productNameController;
  final TextEditingController descriptionController;
  final String? category;
  final io.File image;

  const AddProductController({
    required this.productNameController,
    required this.descriptionController,
    required this.category,
    required this.image
  });

  Future<String> addProduct() async {
      if(checkInputValues(productNameController, descriptionController) == "Ok"){
        String documentId = await FireStoreController().addToProductsCollection(productNameController.text, descriptionController.text, category);


        CloudStorageController().uploadProductImage(image, documentId);

        productNameController.clear();
        descriptionController.clear();

        return "Added Successfully!";
      }else{
        return checkInputValues(productNameController, descriptionController);
      }
  }

  String checkInputValues(
      TextEditingController productNameController,
      TextEditingController descriptionController,
      ) {
    if (acceptableProductName(productNameController.text) != "Ok") {
      return acceptableProductName(productNameController.text);
    }
    if (acceptableDescription(descriptionController.text) != "Ok") {
      return acceptableDescription(descriptionController.text);
    }
    return "Ok";
  }

  String acceptableProductName(String str) {
    if (str.isEmpty) {
      return "Product Name cannot be empty";
    }
    if(str.length > 25){
      return "Product Name cannot have more than 25 chars.";
    }
    return "Ok";
  }

  String acceptableDescription(String str) {
    if (str.isEmpty) {
      return "Description cannot be empty";
    }
    if(str.length > 500){
      return "Description cannot have more than 500 chars";
    }
    return "Ok";
  }
}
