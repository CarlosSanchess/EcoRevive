import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:register/Models/ProductInfo.dart';
import 'dart:io';
import '../Auth/Auth.dart';
import '../Controllers/ChatController.dart';
import 'package:image_picker/image_picker.dart';

class Chat extends StatelessWidget {
  final String receiverId;
  final ProductInfo product;
  Chat({Key? key, required this.receiverId, required this.product}) : super(key: key);

  final TextEditingController textController = TextEditingController();
  final ChatController chatController = ChatController();
  final Auth auth = Auth();
  File? image;

  void sendMessage() async {
    await chatController.sendMessage(receiverId, textController.text, textController.text, image);
    textController.clear();
    image = null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.network(
              product.imageURL,
              width: 80,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 8), // Add some spacing
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.productName),
                Text(product.category),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [

          Expanded(
            child: buildAllMessages(),
          ),

          writeMessage(),
        ]
      ),
    );
  }

  Widget buildAllMessages() {
    String senderId = auth.currentUser!.uid;
    return StreamBuilder(
        stream: ChatController().getMessages(product.productID, receiverId, senderId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          else {
            return ListView(
              children:
                snapshot.data!.docs.map((doc) => buildSingleMessage(doc)).toList()
            );
          }
        }
    );
  }

  Widget buildSingleMessage(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<Widget> messageWidgets = [];

    if (data["imageURL"] != null) {
      messageWidgets.add(Image.network(data["imageURL"]));
    }

    if (data["message"] != null && data["message"].isNotEmpty) {
      messageWidgets.add(Text(data["message"]));
    }

    return Column(
      children: messageWidgets,
    );
  }

  Widget writeMessage() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () async {
            final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

            if (picked != null) {
              image = File(picked.path);
            } else {
              print('No image selected.');
            }
          },
        ),
        Expanded(
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: "Type a message",
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: sendMessage,
        ),
      ],
    );
  }
}