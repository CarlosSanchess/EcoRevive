import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Controllers/ChatController.dart';
import 'UserChats.dart';
import 'package:register/Models/ProductInfo.dart';
import 'package:register/Controllers/CloudStorageController.dart';

class ProductsChats extends StatefulWidget {
  @override
  _ProductsChatState createState() => _ProductsChatState();
}

class _ProductsChatState extends State<ProductsChats> {
  final ChatController chatController = ChatController();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Chats'),
      ),
      body: _selectedIndex == 0
          ? buildProductsPage(chatController.getUserChats(userId), 'Products')
          : buildProductsPage(chatController.getUserChats(userId), 'DeletedProducts'),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Deleted Chats',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget buildProductsPage(Stream<QuerySnapshot> chatsStream, String collectionName) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        } else if(snapshot.hasError){
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Set<String> displayedProductIds = <String>{};
          List<Widget> listTiles = [];

          for (var doc in snapshot.data!.docs) {
            String productId = doc['productId'];

            if (!displayedProductIds.contains(productId)) {
              displayedProductIds.add(productId);

              listTiles.add(
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection(collectionName).doc(productId).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> productSnapshot) {
                    if (productSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (productSnapshot.hasError || !productSnapshot.data!.exists) {
                      return Container();
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
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(imageUrl),
                              ),
                            ),
                          ),
                          title: Text(
                            productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(description),
                              SizedBox(height: 4),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserChats(productId: productId, productName: productName, collection: collectionName),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }
          }

          return ListView(
            children: listTiles,
          );
        }
      },
    );
  }
}