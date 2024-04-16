import 'package:flutter/material.dart';
import 'package:register/Pages/addProduct.dart';
import 'package:register/Pages/Profile.dart';

import 'filterProduct.dart';





class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset('lib/Imgs/Icon.png', height: 40,),
            const SizedBox(width: 10),
            const Text(
              'EcoRevive',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
    ),
      body:  filterProduct(),
        bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.search,
                    size: 35,
                    color: Colors.black
              ),
              onPressed: () {
              },
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add_box,
                size: 37,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addProduct()),);
              },
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.person,
                size: 35,
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
