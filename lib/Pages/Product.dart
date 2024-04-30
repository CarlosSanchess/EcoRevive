import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:register/Auth/Auth.dart';
import 'package:register/Controllers/ChatController.dart';
import 'package:register/Models/ProductInfo.dart';
import 'package:register/Controllers/CloudStorageController.dart';

import 'Chat.dart';

class ProductPage extends StatelessWidget {
  final ProductInfo product;
  ProductPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product.imageURL,
                    width: MediaQuery.of(context).size.width - 32,
                    height: 200,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 40),
                  const Text(
                    'Owned By:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<String>(
                    future: CloudStorageController().getDownloadURL('ProductImages/${product.productID}'),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        snapshot.data ?? "No image Found"; // Assigning to snapshot.data
                        return Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(snapshot.data!),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10), // Space between image and text
                            Text(
                              product.UserID.substring(0,20),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () async {
                  String sender = Auth().currentUser!.uid;
                  bool flag = await ChatController().chatExists(product.productID, sender, product.UserID);

                  if (!flag) ChatController().initiateChat(product.productID, sender, product.UserID);

                  Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(receiverId: product.UserID ,product: product)));
                },
                child: const Text('Chat'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
