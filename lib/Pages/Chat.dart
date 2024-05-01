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
    await chatController.sendMessage(product.productID, receiverId, textController.text, image);
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
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.productName, style: Theme.of(context).appBarTheme.titleTextStyle,),
                Opacity(opacity: 0.7, child: Text(product.category, style: const TextStyle(fontSize: 16.0),),),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          Expanded(
            child: buildAllMessages(),
          ),

          writeMessage(context),
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
            return const Center(child: CircularProgressIndicator());
          }
          else {
            return ListView(
              children:
                snapshot.data!.docs.map((doc) => buildSingleMessage(context, doc)).toList()
            );
          }
        }
    );
  }

  Widget buildSingleMessage(BuildContext context, DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<Widget> messageWidgets = [];

    if (data["imageURL"] != null) {
      messageWidgets.add(Image.network(data["imageURL"]));
    }

    if (data["message"] != null && data["message"].isNotEmpty) {
      messageWidgets.add(Text(data["message"]));
    }
    bool isReceiver = data["receiverID"] == receiverId;
    return Align(

      alignment: isReceiver ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 1,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: ChatBubble(
          isReceiver: isReceiver,
          content: Column(
            crossAxisAlignment: isReceiver ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: messageWidgets,
          ),
        ),
      ),
    );
  }

  Widget writeMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30.0),

      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Widget content;
  final bool isReceiver;

  const ChatBubble({super.key, required this.content, required this.isReceiver});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: isReceiver ? Colors.indigo : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(15.0),
          topRight: const Radius.circular(15.0),
          bottomLeft: isReceiver ? const Radius.circular(15.0) : const Radius.circular(0),
          bottomRight: isReceiver ? const Radius.circular(0) : const Radius.circular(15.0),
        ),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontSize: 16.0),
        child: content,
      ),
    );
  }
}