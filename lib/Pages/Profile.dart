import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register/Pages/ChangePassword.dart';
import 'package:register/Pages/theme_provider.dart';
import '../Auth/Auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:register/Controllers/CloudStorageController.dart';
import 'package:register/Pages/Login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ThemeProvider themeProvider;
  final auth = Auth();
  File? selectedImage;
  String? path = 'PFPImages/${Auth().currentUser?.uid}';
  String? downloadURL;

  Future<void> pickImageFromGallery() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage == null) {
        print('No image selected.');
        return;
      }
      final imageTemp = File(pickedImage.path);
      setState(() {
        selectedImage = imageTemp;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Save Image?'),
            content: const Text('Do you want to save the selected image?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  var currentUser = Auth().currentUser;
                  if (currentUser != null) {
                    CloudStorageController().uploadPFPImage(selectedImage!, currentUser.uid);
                  } else {
                    print("Can't find that user");
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ).then((value) {
        if (value == false) {
          setState(() {
            selectedImage = null;
          });
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<String?> existsPhoto() async {
    try {
      downloadURL = await CloudStorageController().getDownloadURL(path!);
      return downloadURL;
    } catch (e) {
      print("Doesn't exist photo");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);

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
      body: SingleChildScrollView(
        child: Column(
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
                                leading: const Icon(Icons.photo_library),
                                title: const Text('Choose from gallery'),
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
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!)
                        : null,
                    child: selectedImage == null
                        ? FutureBuilder<String?>(
                      future: existsPhoto(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting ||
                            snapshot.data == null) {
                          return const Icon(Icons.add_a_photo, size: 70);
                        } else {
                          return ClipOval(
                            child: Image.network(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            ),
                          );
                        }
                      },
                    )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder<String?>(
                  future: auth.getEmail(),
                  builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      final email = snapshot.data ?? 'No email';
                      final theme = themeProvider.getTheme();
                      final textColor = theme.brightness == Brightness.light
                          ? Colors.grey[700]
                          : theme.textTheme.displayLarge!.color;
                      return Text(
                        email,
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
                color: themeProvider.getTheme().brightness == Brightness.dark
                    ? Colors.grey[850]
                    : Colors.grey[200],
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      children: [
                        Icon(
                          themeProvider.getTheme().brightness == Brightness.dark
                              ? Icons.wb_sunny
                              : Icons.dark_mode,
                          color: themeProvider.getTheme().brightness == Brightness.dark
                              ? Colors.amber
                              : Colors.indigo,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          themeProvider.getTheme().brightness == Brightness.dark
                              ? 'Switch to Light Mode'
                              : 'Switch to Dark Mode',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeProvider.getTheme().appBarTheme.iconTheme!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Switch(
                      value: themeProvider.getTheme().brightness == Brightness.dark,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      activeColor: themeProvider.getTheme().hintColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Container(
              color: themeProvider.getTheme().brightness == Brightness.dark
                  ? Colors.grey[850]
                  : Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 300,
                            child: _buildButtonWithIcon(
                              icon: Icons.shopping_bag,
                              text: 'My Products',
                              onPressed: () {},
                              context: context,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 300,
                            child: _buildButtonWithIcon(
                              icon: Icons.lock,
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
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 300,
                            child: _buildButtonWithIcon(
                              icon: Icons.logout,
                              text: 'Log Out',
                              onPressed: () {
                                auth.signOut();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login(
                                        switchPages: () {},
                                      )),
                                );
                              },
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonWithIcon({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final textColor = themeProvider.getTheme().brightness == Brightness.dark
        ? Colors.white
        : themeProvider.getTheme().textTheme.bodyLarge!.color;

    return ListTile(
      onTap: onPressed,
      leading: CircleAvatar(
        backgroundColor: themeProvider.getTheme().primaryColor,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: themeProvider.getTheme().primaryColor),
        ),
      ),
      title: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }

}
