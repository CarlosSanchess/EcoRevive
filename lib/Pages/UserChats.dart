import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:register/Models/ProductInfo.dart';

import '../Controllers/ChatController.dart';
import '../Controllers/CloudStorageController.dart';
import 'Chat.dart';

class UserChats extends StatefulWidget{
  final String productId;
  final String productName;
  final String collection;

  UserChats({Key? key, required this.productId, required this.productName, required this.collection}) : super(key: key);
  @override
  _UserChatsState createState() => _UserChatsState();
}

class _UserChatsState extends State<UserChats> {
  final ChatController chatController = ChatController();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
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

                if(productId != widget.productId){
                  return Container();
                }

                String otherUserId = chat['participants'].firstWhere((id) => id != userId);

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('Users').doc(otherUserId).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (userSnapshot.hasError) {
                      return Text('Something went wrong a');
                    }

                    String username = userSnapshot.data!['username'];

                    return FutureBuilder<String>(
                      future: CloudStorageController().getDownloadURL('PFPImages/$otherUserId'),
                      builder: (BuildContext context, AsyncSnapshot<String> imageSnapshot) {
                        if (imageSnapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        String imageUrl = imageSnapshot.data ?? '';

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection(widget.collection).doc(productId).get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> productSnapshot) {
                            if (productSnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            if (productSnapshot.hasError) {
                              return Text('Something went wrong c');
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
                                  return Text('Something went wrong d');
                                }

                                String productImageUrl = imageSnapshot.data!;

                                ProductInfo info = ProductInfo(productName: productName, description: description, category: category, UserID: owner, imageURL: productImageUrl, productID: productId);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[300],
                                      image: imageUrl.isNotEmpty
                                          ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(imageUrl),
                                      )
                                          : null,
                                    ),
                                    child: imageUrl.isNotEmpty
                                        ? null
                                        : Icon(Icons.no_photography_outlined),
                                  ),
                                  title: Text(
                                    username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.chat,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Chat(receiverId: otherUserId, product: info),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                );
                              },
                            );
                          },
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