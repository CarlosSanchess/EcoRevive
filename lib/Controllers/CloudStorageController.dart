import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageController {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadImage(File image, String documentId) async {
    try {
      Reference ref = storage.ref().child("ProductImages/$documentId");
      await ref.putFile(image);
      print("Image uploaded successfully");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }
}
