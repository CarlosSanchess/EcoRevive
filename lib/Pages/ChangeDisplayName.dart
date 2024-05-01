import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Auth/Auth.dart';

class ChangeDisplayNamePage extends StatefulWidget {
  const ChangeDisplayNamePage({Key? key}) : super(key: key);

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
                final newName = _nameController.text;
                if (newName.isNotEmpty) {
                  Provider.of<Auth>(context, listen: false).updateDisplayName(newName).then((_) {
                    Navigator.pop(context);
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
