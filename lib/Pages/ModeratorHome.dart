import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register/Pages/ModerateUsers.dart';
import 'package:register/Pages/theme_provider.dart';

import 'Home.dart';
import 'ModerateProducts.dart';

class ModeratorHome extends StatelessWidget {
  ModeratorHome({super.key});
  late ThemeProvider themeProvider;


  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.getTheme().appBarTheme.backgroundColor,
        title: Text(
          'Moderate Home',
          style: TextStyle(
            color: themeProvider.getTheme().appBarTheme.iconTheme!.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Navigator.canPop(context)
            ? IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: themeProvider.getTheme().appBarTheme.iconTheme!.color,
              ),
            )
            : null,
      ),
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[

            const Spacer(),
            IconButton(
              icon: const Icon(Icons.home,
                size: 45,
                color: Colors.black,
              ),
              onPressed: () {
              },
            ),
            const Spacer(),

          ],
        ),
      ),
    );
  }
}