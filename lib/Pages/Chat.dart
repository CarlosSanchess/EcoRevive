import 'package:flutter/material.dart';
import 'dart:io';
import '../Auth/Auth.dart';
import '../Controllers/ChatController.dart';

class Chat extends StatelessWidget {
  final String receiverID;
  Chat({Key? key, required this.receiverID, required this.image}) : super(key: key);

  final TextEditingController textController = TextEditingController();
  final ChatController chatController = ChatController();
  final Auth auth = Auth();
  final File image;

  void sendMessage() async {
    await chatController.sendMessage(receiverID, textController.text, textController.text, image);
    textController.clear();
  }



  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Chat Page'),
      ),
    );
  }
}