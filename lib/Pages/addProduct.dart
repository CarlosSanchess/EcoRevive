
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register/Controllers/AddProductController.dart';
import 'package:register/Functions/CategorySelector.dart';


//Max Width and Max Height for image
class addProduct extends StatefulWidget{

  addProduct({Key? key}) : super(key: key);

  @override
  State<addProduct> createState() => _addProductState();
}

class _addProductState extends State<addProduct> {
  File? selectedImage;
  double imageHeight = 200;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController productNameController = TextEditingController();

  Future pickImageFromGallery() async{
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
          selectedImage = imageTemp;
      });
    }on PlatformException catch (e){
      print('Failed to Pick image: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const IconButton( // On pressed
          onPressed: null,
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.black, // Optionally, set the color of the icon
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
              child: Column(
                  children: [
                    const Text(
                      'Add Product',
                      textAlign: TextAlign.left, // Align left
                      style: TextStyle(
                        color: Color.fromRGBO(85, 139, 47, 1),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Fill out the information below to post a product',
                      textAlign: TextAlign.left, // Align left
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 50),


                    if (selectedImage != null) 
                        imageDisplay(imageHeight, selectedImage)
                      else  imagePickerContainer(200, () => pickImageFromGallery()),
                    const SizedBox(height: 30),
                    Card(
                        color: Colors.grey.shade200,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: TextField(
                            controller: productNameController,
                            maxLines: 1,
                            decoration: const InputDecoration.collapsed(hintText: "Product Name..."),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                    ),
                    const SizedBox(height: 10),
                    Card(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: TextField(
                          controller: descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration.collapsed(hintText: "Description..."),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CategorySelector(),
                    const SizedBox(height: 30),

                    GestureDetector(
                      onTap: () {
                        if(AddProductController(productNameController: productNameController,
                                                descriptionController: descriptionController,
                                                category: const CategorySelector().getCategory()).addProduct() == "Added Successfully!"){
                              const CategorySelector().resetCategory();
                        }

                      },
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen[800],
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


Widget imagePickerContainer(double height, Future<void> Function() onPressed) {
  return Container(
    width: double.infinity,
    height: height,
    color: Colors.grey[200],
    child: Center(
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: Text('Add Image'),
      ),
    ),
  );
}

Widget imageDisplay(double height,  File? selectedImage) {
  return Container(
    width: double.infinity,
    height: height,
    color: Colors.grey[200],
   child:
    AspectRatio(
        aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
        child: Image.file(
          selectedImage!,
          fit: BoxFit.fill, // Maintain aspect ratio and fill the space
         ),
       ), // If imageUrl is null, display an empty container
    );
}
