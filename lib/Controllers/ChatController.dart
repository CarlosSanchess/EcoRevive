import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:register/API/API.dart';
import 'package:register/Auth/Auth.dart';
import 'package:register/Controllers/CloudStorageController.dart';
import 'package:register/Controllers/FireStoreController.dart';

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

    //send Notification //

    //Get FCM Token userName
    String FCMtoken = await FireStoreController().getFCMTokenFromCollection(receiverID);
    String? userName = await FireStoreController().getUsernameByUid(userId);
    String text = content!.substring(0, content.length < 15 ? content.length : 15);
    print(text);
    if(FCMtoken != "" && userName != null){
      API().sendMessage(FCMtoken, userName, text);
    }
  }

  Stream<QuerySnapshot> getMessages(String productId, String user1Id, String user2Id){
    List<String> buildId = [productId, user1Id, user2Id]..sort();
    String chatId = buildId.join("-");
    return db.collection('Chats').doc(chatId).collection('Messages').orderBy('time').snapshots();
  }

  Stream<QuerySnapshot> getUserChats(String userId){
    return db.collection('Chats').where('participants', arrayContains: userId).snapshots();
  }

  Future<void> verifyTransaction(String chatId) async {
    DocumentReference chatRef = db.collection('Chats').doc(chatId);
    DocumentSnapshot chatSnapshot = await chatRef.get();

    if (chatSnapshot.exists) {
      Map<String, dynamic> data = chatSnapshot.data() as Map<String, dynamic>;
      bool buyerVerified = data['buyerVerified'] ?? false;
      bool sellerVerified = data['sellerVerified'] ?? false;

      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      if (data['participants'][0] == currentUserId) {
        buyerVerified = true;
      } else if (data['participants'][1] == currentUserId) {
        sellerVerified = true;
      }

      if (buyerVerified && sellerVerified) {
        await chatRef.update({
          'buyerVerified': buyerVerified,
          'sellerVerified': sellerVerified,
          'status': 'finished',
        });

        String productId = data['productId'];
        DocumentSnapshot productSnapshot = await db.collection('Products').doc(productId).get();
        if (productSnapshot.exists) {
          Map<String, dynamic> productData = productSnapshot.data() as Map<String, dynamic>;
          Map<String, dynamic> productInfo = {
            'ProductName': productData['ProductName'],
            'Description': productData['Description'],
            'Category': productData['Category'],
            'Owner': productData['Owner'],
          };
          await db.collection('DeletedProducts').doc(productId).set(productInfo);
          await db.collection('Products').doc(productId).delete();
        }

        QuerySnapshot chatsSnapshot = await db.collection('Chats').where('productId', isEqualTo: productId).get();
        for (DocumentSnapshot chat in chatsSnapshot.docs) {
          await chat.reference.update({'status': 'finished'});
        }
      } else {
        await chatRef.update({
          'buyerVerified': buyerVerified,
          'sellerVerified': sellerVerified,
        });
      }
    } else {
      throw Exception("Chat not found");
    }
  }

}