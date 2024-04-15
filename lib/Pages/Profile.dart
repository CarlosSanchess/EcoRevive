import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Auth/Auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'Login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;
  final auth = Auth();
  File? selectedImage;

  Future<void> pickImageFromGallery() async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) {
        print('No image selected.');
        return;
      }
      final imageTemp = File(pickedImage.path);
      setState(() {
        selectedImage = imageTemp;
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double increaseFactor = 1.15;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('Choose from gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                pickImageFromGallery();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  radius: screenSize.width * 0.15 * increaseFactor,
                  backgroundImage: selectedImage != null ? FileImage(selectedImage!) : null,
                  child: selectedImage == null ? Icon(Icons.add_a_photo, size: screenSize.width * 0.15 * increaseFactor) : null,
                ),
              ),
              SizedBox(height: 20 * increaseFactor),
              FutureBuilder<String?>(
                future: auth.getEmail(),
                builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    final email = snapshot.data ?? 'No email';
                    return Text(
                      email,
                      style: TextStyle(
                        fontSize: 16 * increaseFactor,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 20 * increaseFactor),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10 * increaseFactor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Switch to Dark Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                  activeColor: Color.fromRGBO(85, 139, 47, 1),
                ),
              ],
            ),
          ),
          SizedBox(height: 20 * increaseFactor),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Padding(
                padding: EdgeInsets.only(top: 40 * increaseFactor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16 * increaseFactor),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 300 * increaseFactor,
                            child: _buildButtonWithIcon(
                              text: 'Product List',
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(height: 16 * increaseFactor),
                          SizedBox(
                            width: 300 * increaseFactor,
                            child: _buildButtonWithIcon(
                              text: 'Change Password',
                              onPressed: () async {
                                bool isLoggedIn = await auth.isLoggedIn();
                                print(isLoggedIn);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24 * increaseFactor),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120 * increaseFactor,
                          child: ElevatedButton(
                            onPressed: () {
                              auth.signOut();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Login(switchPages: () {})),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromRGBO(85, 139, 47, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Log Out'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonWithIcon({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromRGBO(85, 139, 47, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(text),
    );
  }
}
