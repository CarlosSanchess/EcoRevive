import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io' as io;

class CloudStorageController{

  final storage = FirebaseStorage.instance;


  void uploadImage(io.File image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(image);
    print("ola");
    uploadTask.then((res) {
      res.ref.getDownloadURL();
      print(res.ref.getDownloadURL());
    });

  }
}