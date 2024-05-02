import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:register/Models/ProductInfo.dart';

import '../Controllers/ChatController.dart';
import '../Controllers/CloudStorageController.dart';
import 'Chat.dart';

class UserChats extends StatefulWidget{
  @override
  _UserChatsState createState() => _UserChatsState();
}

class _UserChatsState extends State<UserChats>{
  final ChatController chatController = ChatController();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your chats'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatController.getUserChats(userId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index){
                DocumentSnapshot chat = snapshot.data!.docs[index];
                String chatId = chat.id;
                String productId = chat['productId'];
                Future<String> imageUrl = CloudStorageController().getDownloadURL('ProductImages/$productId');

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('Products').doc(productId).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> productSnapshot) {
                    if (productSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (productSnapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    String productName = productSnapshot.data!['ProductName'];
                    String description = productSnapshot.data!['Description'];
                    String category = productSnapshot.data!['Category'];
                    String owner = productSnapshot.data!['Owner'];

                    return FutureBuilder<String>(
                      future: CloudStorageController().getDownloadURL('ProductImages/$productId'),
                      builder: (BuildContext context, AsyncSnapshot<String> imageSnapshot) {
                        if (imageSnapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (imageSnapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        String imageUrl = imageSnapshot.data!;

                        ProductInfo info = ProductInfo(productName: productName, description: description, category: category, UserID: owner, imageURL: imageUrl, productID: productId);

                        return ListTile(
                          title: Text(productName),
                          trailing: IconButton(
                            icon: Icon(Icons.chat),
                            onPressed: () {
                              if (info.UserID == userId) {
                                String otherUserId = chat['participants'].firstWhere((userId) => userId != info.UserID);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => Chat(receiverId: otherUserId, product: info)));
                              } else {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => Chat(receiverId: info.UserID, product: info)));
                              }
                            }
                          ),
                          // Add more details about the chat if needed
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}