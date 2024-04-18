import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:register/Controllers/AddProductController.dart';
import 'package:mockito/mockito.dart';

void main() {

  test('_checkInputValues returns "Ok" for valid inputs', () {
    TextEditingController productNameController = TextEditingController(text: 'Product');
    TextEditingController descriptionController = TextEditingController(text: 'Description');
    AddProductController controller = AddProductController(
      productNameController: productNameController,
      descriptionController: descriptionController,
      category: 'Test',
      image:MockFile(),
    );

    expect(controller.acceptableDescription(descriptionController.text), "Ok");
  });

  test('checkInputValues returns appropriate error message for invalid inputs', () {
    TextEditingController productNameController = TextEditingController(text: '');
    TextEditingController descriptionController = TextEditingController(text: '');
    AddProductController controller = AddProductController(
      productNameController: productNameController,
      descriptionController: descriptionController,
      category: 'Test',
      image: MockFile(),
    );

    expect(controller.checkInputValues(productNameController, descriptionController), "Product Name cannot be empty");
  });

  test('acceptableDescription returns "Ok" for valid description', () {
    TextEditingController descriptionController = TextEditingController(text: 'Otimas Sapatilhas.');
    AddProductController controller = AddProductController(
      productNameController: TextEditingController(),
      descriptionController: descriptionController,
      category: 'Test',
      image: MockFile(),
    );

    expect(controller.acceptableDescription(descriptionController.text), "Ok");
  });

  test('acceptableDescription returns appropriate error message for invalid description', () {
    TextEditingController descriptionController = TextEditingController(text: '');
    AddProductController controller = AddProductController(
      productNameController: TextEditingController(),
      descriptionController: descriptionController,
      category: 'Test',
      image: MockFile(),
    );

    expect(controller.acceptableDescription(descriptionController.text), "Description cannot be empty");
  });

  test('acceptableDescription returns appropriate error message for invalid description', () {
    TextEditingController descriptionController = TextEditingController(text:"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed malesuada leo vitae lorem molestie, vel placerat elit tincidunt. Phasellus vehicula lacus non justo rutrum, id laoreet elit ullamcorper. Nulla facilisi. Integer ullamcorper semper turpis, vel laoreet ante posuere nec. Fusce ut velit sit amet est aliquet fringilla. Sed ac lacus vel tortor sagittis vulputate. Nullam convallis, quam vitae consectetur ultricies, justo libero gravida quam, id ultrices nisi purus quis ex. Vivamus rhoncus convallis vestibulum. Sed vel molestie nulla. Integer ultricies, urna vitae bibendum consectetur, enim mi efficitur sem, nec venenatis felis magna vel nisl. Ut ultrices enim et turpis mattis, vitae congue ante blandit. Vivamus congue fermentum arcu nec viverra. Quisque congue ante non mi interdum, ac consequat quam egestas. Phasellus eu feugiat urna.");

    AddProductController controller = AddProductController(
      productNameController: TextEditingController(),
      descriptionController: descriptionController,
      category: 'Test',
      image: MockFile(),
    );
    expect(controller.acceptableDescription(descriptionController.text), "Description cannot have more than 500 chars");
  });
}

class MockFile extends Mock implements File {
  @override
  Future<File> writeAsBytes(List<int> bytes,
      {FileMode mode = FileMode.write, bool flush = false}) async {
    return Future.value(this);
  }
}


