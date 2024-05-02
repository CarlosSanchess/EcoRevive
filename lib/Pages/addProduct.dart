import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:register/Controllers/AddProductController.dart';
import 'package:register/Functions/CategorySelector.dart';
import 'package:register/Pages/theme_provider.dart';
import 'package:register/Pages/Home.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File? selectedImage;
  double imageHeight = 200;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController productNameController = TextEditingController();

  Future pickImageFromGallery() async {
    try {
      final image =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        selectedImage = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to Pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.getTheme().appBarTheme.backgroundColor,
        title: Text(
          'Add Product',
          style: TextStyle(
            color: themeProvider.getTheme().appBarTheme.iconTheme!.color,
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            //Navigator.of(context).pushReplacement(
            //  MaterialPageRoute(builder: (context) => Home()),
            //);
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: themeProvider.getTheme().appBarTheme.iconTheme!.color,
          ),
        ),
      ),
      backgroundColor: themeProvider.getTheme().colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 20, top: 0),
              child: Column(
                children: [
                  const Text(
                    'Fill out the information below to post a product',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (selectedImage != null)
                    imageDisplay(imageHeight, selectedImage)
                  else
                    imagePickerContainer(
                      200,
                          () => pickImageFromGallery(),
                      isDarkMode: themeProvider.getTheme().brightness ==
                          Brightness.dark,
                    ),
                  const SizedBox(height: 30),
                  Card(
                    color: themeProvider.getTheme().cardColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: TextField(
                        controller: productNameController,
                        maxLines: 1,
                        decoration: const InputDecoration.collapsed(
                          hintText: "Product Name...",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          color: themeProvider
                              .getTheme()
                              .textTheme
                              .bodyLarge!
                              .color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    color: themeProvider.getTheme().cardColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration.collapsed(
                          hintText: "Description...",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          color: themeProvider
                              .getTheme()
                              .textTheme
                              .bodyLarge!
                              .color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const CategorySelector(),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      AddProductController(
                        productNameController: productNameController,
                        descriptionController: descriptionController,
                        category: const CategorySelector().getCategory(),
                        image: selectedImage!,
                      ).addProduct();

                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddProduct()),
                      );
                    },
                    child: Consumer<ThemeProvider>(
                      builder: (context, themeProvider, _) {
                        return Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: themeProvider.getTheme().primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              "Post Product",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 100)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget imagePickerContainer(
    double height, Future<void> Function() onPressed,
    {required bool isDarkMode}) {
  final color = isDarkMode ? Colors.grey[800] : Colors.grey[200];
  return Container(
    width: double.infinity,
    height: height,
    color: color,
    child: Center(
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: const Text('Add Image'),
      ),
    ),
  );
}

Widget imageDisplay(double height, File? selectedImage) {
  return Container(
    width: double.infinity,
    height: height,
    color: Colors.grey[800],
    child: AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.file(
        selectedImage!,
        fit: BoxFit.fill,
      ),
    ),
  );
}
