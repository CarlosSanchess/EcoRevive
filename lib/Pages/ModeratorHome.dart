import 'package:flutter/material.dart';
import 'package:register/Pages/ModerateUsers.dart';

import 'Home.dart';
import 'ModerateProducts.dart';

class ModeratorHome extends StatelessWidget {
  const ModeratorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to moderate products page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ModerateProducts( category: 'all',)),
                );
              },
              child: Text('Moderate Products', style: TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to moderate suspicious products page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ModerateProducts( category: 'suspicious',)),
                );
              },
              child: Text('Moderate Suspicious Products', style: TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ModerateUsers()),
                );
              },
              child: Text('Moderate Users', style: TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to moderate suspicious users page
              },
              child: Text('Moderate Suspicious Users', style: TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to moderate chats page
              },
              child: Text('Moderate Chats', style: TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width , 50),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              child: Text('Home', style: TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}