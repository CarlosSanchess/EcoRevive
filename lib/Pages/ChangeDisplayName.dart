import 'package:flutter/material.dart';
import '../Auth/Auth.dart';
import 'Profile.dart';

class ChangeDisplayNamePage extends StatefulWidget {
  final Auth auth;

  const ChangeDisplayNamePage({Key? key, required this.auth}) : super(key: key);

  @override
  _ChangeDisplayNamePageState createState() => _ChangeDisplayNamePageState();
}

class _ChangeDisplayNamePageState extends State<ChangeDisplayNamePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Display Name'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'New Display Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newName = _nameController.text.trim();
                if (newName.isNotEmpty) {
                  widget.auth.updateDisplayName(newName).then((_) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  });
                }
              },
              child: const Text('Save New Name'),
            ),
          ],
        ),
      ),
    );
  }
}

