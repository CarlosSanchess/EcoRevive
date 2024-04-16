import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register/Auth/Auth.dart';
import 'package:register/Pages/theme_provider.dart';
import 'ChangePassword.dart';
import 'Login.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.getTheme().appBarTheme.backgroundColor,
        title: Text(
          'Profile',
          style: TextStyle(
            color: themeProvider.getTheme().appBarTheme.iconTheme!.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: themeProvider.getTheme().appBarTheme.iconTheme!.color,
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
                  radius: 70,
                  backgroundImage: selectedImage != null ? FileImage(selectedImage!) : null,
                  child: selectedImage == null ? Icon(Icons.add_a_photo, size: 70) : null,
                ),
              ),
              SizedBox(height: 20),
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
                        fontSize: 16,
                        color: themeProvider.getTheme().textTheme!.headline1!.color,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Switch to Dark Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: themeProvider.getTheme().appBarTheme.iconTheme!.color,
                    ),
                  ),
                ),
                Switch(
                  value: themeProvider.getTheme().brightness == Brightness.dark,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  activeColor: themeProvider.getTheme().hintColor,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 300,
                            child: _buildButtonWithIcon(
                              text: 'Product List',
                              onPressed: () {},
                              context: context,
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: 300,
                            child: _buildButtonWithIcon(
                              text: 'Change Password',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                                );
                              },
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
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
                              backgroundColor: themeProvider.getTheme().primaryColor,
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

  Widget _buildButtonWithIcon(
      {required String text, required VoidCallback onPressed, required BuildContext context}) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: themeProvider.getTheme().primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(text),
    );
  }
}
