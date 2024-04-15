import 'package:flutter/material.dart';
import 'package:register/Controllers/FireStoreController.dart';

class AddProductController {
  final TextEditingController productNameController;
  final TextEditingController descriptionController;
  final String? category;

  const AddProductController({
    required this.productNameController,
    required this.descriptionController,
    required this.category
  });

  String addProduct() {
      if(_checkInputValues(productNameController, descriptionController) == "Ok"){
        FireStoreController().addToProductsCollection(productNameController.text, descriptionController.text, category);
        productNameController.clear();
        descriptionController.clear();
        return "Added Successfully!";
      }else{
        return _checkInputValues(productNameController, descriptionController);
      }
  }

  String _checkInputValues(
      TextEditingController productNameController,
      TextEditingController descriptionController,
      ) {
    if (_acceptableProductName(productNameController.text) != "Ok") {
      return _acceptableProductName(productNameController.text);
    }
    if (_acceptableDescription(descriptionController.text) != "Ok") {
      return _acceptableDescription(descriptionController.text);
    }
    return "Ok";
  }

  String _acceptableProductName(String str) {
    if (str.isEmpty) {
      return "Product Name cannot be empty";
    }
    if(str.length > 25){
      return "Product Name cannot have more than 25 chars.";
    }
    return "Ok";
  }

  String _acceptableDescription(String str) {
    if (str.isEmpty) {
      return "Description cannot be empty";
    }
    if(str.length > 200){
      return "Description cannot have more than 200 chars";
    }
    return "Ok";
  }
}
