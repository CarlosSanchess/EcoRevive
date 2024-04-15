import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Auth/Auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;
  final auth = Auth(); // Create an instance of Auth
  File? selectedImage; // Add this variable to hold the user's selected image

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black, // Make the title text black
            fontWeight: FontWeight.bold, // Make the title text bold
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black, // Make the back button icon black
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Profile Picture and User Information
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Profile Picture
              GestureDetector(
                onTap: () {
                  // Open options to select image
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
                  radius: 50,
                  backgroundImage: selectedImage != null ? FileImage(selectedImage!) : null,
                  child: selectedImage == null ? Icon(Icons.add_a_photo, size: 40) : null,
                ),
              ),
              const SizedBox(height: 8), // Add some space between the picture and text
              // User Information
              FutureBuilder<String?>(
                future: auth.getEmail(), // Get the current user's email
                builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show a loading spinner while waiting
                  } else {
                    final email = snapshot.data ?? 'No email'; // Use the email if it's available, otherwise use 'No email'
                    return Text(
                      email,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold, // Make the email text bold
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Dark Mode Container
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[300]!), // Add top border
                bottom: BorderSide(color: Colors.grey[300]!), // Add bottom border
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Switch to Dark Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Make the text bold
                      color: Colors.black, // Make the text color black
                    ),
                  ),
                ),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                      // Handle switching between light and dark mode here
                    });
                  },
                  activeColor: Color.fromRGBO(85, 139, 47, 1), // Set the color of the switch thumb when active
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Grey background container
          Expanded(
            child: Container(
              color: Colors.grey[200], // Grey background color
              child: Padding(
                padding: const EdgeInsets.only(top: 50), // Add padding to move the buttons down
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16), // Add padding for the buttons container
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 300, // Fixed width for the buttons
                            child: _buildButtonWithIcon(
                              text: 'Product List',
                              onPressed: () {
                                // Navigate to the product list screen
                              },
                            ),
                          ),
                          const SizedBox(height: 16), // Add space between buttons
                          SizedBox(
                            width: 300, // Fixed width for the buttons
                            child: _buildButtonWithIcon(
                              text: 'Change Password',
                              onPressed: () {
                                // Navigate to the change password screen
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24), // Add more space between buttons and log out button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              // Log out the user
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromRGBO(85, 139, 47, 1), // Set the background color of the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text('Log Out'),
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
        backgroundColor: Color.fromRGBO(85, 139, 47, 1), // Set the background color of the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(text),
    );
  }
}
