import 'dart:io';

import 'package:flutter/material.dart';
import 'package:register/Controllers/UserController.dart';
import 'package:register/Pages/ModeratorHome.dart';
import 'package:register/Models/UsersInfo.dart';
import 'package:register/Controllers/FireStoreController.dart';

class ModerateUsers extends StatefulWidget {
  const ModerateUsers({Key? key}) : super(key: key);

  @override
  State<ModerateUsers> createState() => _ModerateUsersState();
}

class _ModerateUsersState extends State<ModerateUsers> {
  late Future<List<UsersInfo>> _usersFuture;
  late Future<List<UsersInfo>> _disabledUsersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = loadUsers();
    _disabledUsersFuture = loadDisabledUsers();
  }

  Future<List<UsersInfo>> loadUsers() async {
    return FireStoreController().getAllUsers();
  }

  Future<List<UsersInfo>> loadDisabledUsers() {
    return FireStoreController().getAllDisableUsers();
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
        title: const Text('Manage Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<UsersInfo>>(
                future: _usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error loading users: ${snapshot.error}'),
                    );
                  } else {
                    List<UsersInfo>? users = snapshot.data;
                    if (users == null || users.isEmpty) {
                      return const Center(
                        child: Text('No active users.'),
                      );
                    } else {
                      return Column(
                        children: [
                          _buildTitle('Active Users', Colors.green, Colors.teal),
                          Expanded(
                            child: ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 4.0,
                                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(9.0),
                                    title: Text(
                                      users[index].displayName,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(users[index].email),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.block),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text("Confirm Soft Ban"),
                                                  content: Text("Are you sure you want to soft ban ${users[index].displayName}?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        UserController(userInfo: users[index]).disableUser();
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => const ModerateUsers()),
                                                        );
                                                      },
                                                      child: const Text(
                                                        "Soft Ban",
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
                                        IconButton(
                                          icon: const Icon(Icons.close_outlined,
                                          color: Colors.redAccent,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text("Confirm Ban"),
                                                  content: Text("Are you sure you want to ban ${users[index].displayName}? (It can't be reverted)"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        UserController(userInfo: users[index]).deleteUser();
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => const ModerateUsers()),
                                                        );
                                                      },
                                                      child: const Text(
                                                        "Ban",
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
            FutureBuilder<List<UsersInfo>>(
              future: _disabledUsersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading disabled users: ${snapshot.error}'),
                  );
                } else {
                  List<UsersInfo>? users = snapshot.data;
                  if (users == null || users.isEmpty) {
                    return const SizedBox.shrink();
                  } else {
                    return Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                        _buildTitle('Disabled Users', Colors.redAccent, Colors.red),
                          Expanded(
                            child: ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 4.0,
                                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(9.0),
                                    title: Text(
                                      users[index].displayName,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(users[index].email),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.check_box,
                                            color: Colors.teal,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text("Confirm Enable User"),
                                                  content: Text("Are you sure you want to enable ${users[index].displayName}?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        UserController(userInfo: users[index]).enableUser();
                                                        sleep(2 as Duration); // TODO
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => const ModerateUsers()),
                                                        );
                                                      },
                                                      child: const Text(
                                                        "Enable",
                                                        style: TextStyle(
                                                          color: Colors.green,
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
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
