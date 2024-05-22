import 'package:flutter/material.dart';
import 'package:register/Controllers/FireStoreController.dart';
import 'package:register/Models/ChatInfo.dart';
import 'package:register/Pages/ModeratorHome.dart';

class ModerateChats extends StatefulWidget {
  const ModerateChats({Key? key}) : super(key: key);

  @override
  State<ModerateChats> createState() => _ModerateChatsState();
}

class _ModerateChatsState extends State<ModerateChats> {
  late Future<List<ChatInfo>> _chatsFuture;

  @override
  void initState() {
    super.initState();
    _chatsFuture = loadChats();
  }

  Future<List<ChatInfo>> loadChats() async {
    return FireStoreController().getAllChatInfo();
  }

  Widget _buildTitle(String text, Color color1, Color color2) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ModeratorHome()),
            );
          },
        ),
        title: const Text('Moderate Chats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<ChatInfo>>(
                future: _chatsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error loading chats: ${snapshot.error}'),
                    );
                  } else {
                    List<ChatInfo>? chats = snapshot.data;
                    if (chats == null || chats.isEmpty) {
                      return const Center(
                        child: Text('No chat messages available.'),
                      );
                    } else {
                      return Column(
                        children: [
                          _buildTitle('Chat Messages', Colors.green, Colors.teal),
                          Expanded(
                            child: ListView.builder(
                              itemCount: chats.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 4.0,
                                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(9.0),
                                    title: Text(
                                      'Chat: ${chats[index].nameID1} and ${chats[index].nameID2}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(chats[index].nameProduct),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text("Confirm Delete"),
                                                  content: Text("Are you sure you want to delete this chat? (It can't be reverted)"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        FireStoreController().removeChat(chats[index].chatId);
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => const ModerateChats()),
                                                        );
                                                      },
                                                      child: const Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
