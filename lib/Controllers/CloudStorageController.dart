import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<File?> getImageByProdID(String documentID) async { // Not Working yet
    final tempDir = await getTemporaryDirectory();
    final file = File('$tempDir/$documentID');

    try {
      Reference ref = storage.ref().child("ProductImages/$documentID");
      await ref.writeToFile(file);
      return file;
    } catch (e) {
      print("Error Downloading Image: $e");
      return null;
    }
  }
}
//Future<File?> getImageByUid(String UserID) async{

//  }
