import 'package:flutter/material.dart';
import 'package:register/Controllers/FireStoreController.dart';

class AddProductController {
  final TextEditingController productNameController;
  final TextEditingController descriptionController;

  const AddProductController({
    required this.productNameController,
    required this.descriptionController,
  });

  String addProduct() {
      if(_checkInputValues(productNameController, descriptionController) == "Ok"){
        FireStoreController().addToDataBase(productNameController.text, descriptionController.text);
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
    return "Ok";
  }

  String _acceptableDescription(String str) {
    if (str.isEmpty) {
      return "Description cannot be empty";
    }
    return "Ok";
  }
}
