import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageController {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final String path = "gs://vertical-prototype-70c6c.appspot.com";

  Future<void> uploadProductImage(File image, String documentId) async {
    try {
      Reference ref = storage.ref().child("ProductImages/$documentId");
      await ref.putFile(image);
      print("Image uploaded successfully");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> uploadPFPImage(File image, String UserID) async {
    try {
      Reference ref = storage.ref().child("PFPImages/$UserID");
      await ref.putFile(image);
      print("Image uploaded successfully");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<String> getDownloadURL(String storageURL) async {
    try {
      Reference imageRef = storage.ref().child(storageURL);
      return await imageRef.getDownloadURL();
    } catch (e) {
      print("Error getting Download URL: $e");
      return Future.error("Failed to get download URL");
    }
  }
}
