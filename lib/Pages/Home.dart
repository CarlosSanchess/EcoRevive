import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Eco Revive',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30
            ),
          textAlign: TextAlign.center,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0), // Adjust the value as needed
        child: Center(
          child: Text(
            'Home Page, click on the "+" Icon to add product, on the "Profile" icon to access your Profile',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
        bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.search,
                    size: 35,
                    color: Colors.black
              ),
              onPressed: () {
                // Add your onPressed logic here
              },
            ),
            const Spacer(), // Espaço entre os ícones e as extremidades
            IconButton(
              icon: const Icon(Icons.add_box,
                size: 37,
                color: Colors.black,
              ),
              onPressed: () {
                // Add your onPressed logic here
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
                // Add your onPressed logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}
