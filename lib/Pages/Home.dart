import 'package:flutter/material.dart';
import 'package:register/Pages/addProduct.dart';
import 'package:register/Pages/Profile.dart';

import 'UserChats.dart';
import 'filterProduct.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.only(top: 50.0),
        child: FilterProduct(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.chat_bubble_rounded,
                  size: 37,
                  color: Colors.black
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserChats()),);
              },
            ),
            const Spacer(),
            IconButton(
              key: Key('navigate_to_add_product_button'), // Add key here
              icon: const Icon(Icons.add_box,
                size: 39,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddProduct()),);
              },
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.person,
                size: 37,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),);
              },
            ),
          ],
        ),
      ),
    );
  }
}
