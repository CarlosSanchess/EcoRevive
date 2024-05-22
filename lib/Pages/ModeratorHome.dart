import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register/Pages/ModerateChats.dart';
import 'package:register/Pages/ModerateUsers.dart';
import 'package:register/Pages/Profile.dart';
import 'package:register/Pages/theme_provider.dart';
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: themeProvider.getTheme().appBarTheme.iconTheme!.color,
          ),
        ),
      ),
      body: Padding(
        padding:const EdgeInsets.all(25.0),
      child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to moderate products page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ModerateProducts(category: 'all')),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: themeProvider.getTheme().primaryColor, minimumSize: Size(MediaQuery.of(context).size.width, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Moderate Products', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ModerateUsers()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: themeProvider.getTheme().primaryColor, minimumSize: Size(MediaQuery.of(context).size.width, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Moderate Users', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ModerateChats()),
                );              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: themeProvider.getTheme().primaryColor, minimumSize: Size(MediaQuery.of(context).size.width, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Moderate Chats', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home, size: 30),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
