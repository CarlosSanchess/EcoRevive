import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:register/Controllers/CloudStorageController.dart';

import '../Models/Message.dart';

class ChatController{
  final FirebaseStorage storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;

  Future<bool> chatExists(String productId, String user1Id, String user2Id) async {
    List<String> buildId = [productId, user1Id, user2Id]..sort();
    String chatId = buildId.join("-");
    DocumentSnapshot chat = await db.collection('Chats').doc(chatId).get();
    return chat.exists;
  }

  Future<void> initiateChat(String productId, String user1Id, String user2Id) async {
    List<String> buildId = [productId, user1Id, user2Id]..sort();
    String chatId = buildId.join("-");
    //New chat inside the Chats collection
    await db.collection('Chats').doc(chatId).set({'participants': [user1Id, user2Id], 'productId': productId});
  }

  Future<void> sendMessage(String productID, String receiverID, String? content, File? image) async {
    if ((content == null || content.isEmpty) && (image == null || image.path.isEmpty)) {
      throw ArgumentError('Messages cannot be empty');
    }

    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final String userEmail = FirebaseAuth.instance.currentUser!.email!;
    final Timestamp time = Timestamp.now();

    List<String> buildId = [productID, userId, receiverID]..sort();
    String chatId = buildId.join("-");

    String? imageUrl;
    if(image != null && image.path.isNotEmpty){
      imageUrl = await CloudStorageController().uploadChatImage(image, chatId, time);
    }

    Message message = Message(
      senderID: userId,
      receiverID: receiverID,
      senderEmail: userEmail,
      message: content,
      imageURL: imageUrl,
      time: time
    );


    await db.collection('Chats').doc(chatId).collection('Messages').add(message.toMap());
  }

  Stream<QuerySnapshot> getMessages(String productId, String user1Id, String user2Id){
    List<String> buildId = [productId, user1Id, user2Id]..sort();
    String chatId = buildId.join("-");
    return db.collection('Chats').doc(chatId).collection('Messages').orderBy('time').snapshots();
  }

}