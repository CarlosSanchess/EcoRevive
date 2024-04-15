import 'package:flutter/material.dart';

import '../Auth/Auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;
  final auth = Auth(); // Create an instance of Auth

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Profile Picture and User Information
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Profile Picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'lib/Imgs/Icon.png',
                    height: 100,
                    width: 100,
                  ),
                ),
                SizedBox(width: 16), // Add some space between the picture and text
                // User Information
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder<String?>(
                      future: auth.getEmail(), // Get the current user's email
                      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Show a loading spinner while waiting
                        } else {
                          final email = snapshot.data ?? 'No email'; // Use the email if it's available, otherwise use 'No email'
                          return Text(
                            email,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 8),
                    Text(
                      'rebelo@google.com',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            // Dark Mode Container
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!), // Add top border
                  bottom: BorderSide(color: Colors.grey[300]!), // Add bottom border
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text('Switch to Dark Mode'),
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                        // Handle switching between light and dark mode here
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
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
                        padding: EdgeInsets.symmetric(horizontal: 16), // Add padding for the buttons container
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
                            SizedBox(height: 16), // Add space between buttons
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
                      SizedBox(height: 24), // Add more space between buttons and log out button
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
                                foregroundColor: Colors.white, backgroundColor: Colors.blue[700],
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
      ),
    );
  }

  Widget _buildButtonWithIcon({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(text),
    );
  }
}
