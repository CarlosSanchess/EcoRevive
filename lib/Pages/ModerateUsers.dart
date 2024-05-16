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

  @override
  void initState() {
    super.initState();
    _usersFuture = loadUsers();
  }
  Future<List<UsersInfo>> loadUsers() async {
    return FireStoreController().getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ModeratorHome()),
            );
          },
        ),
        title: Text('Users'),
      ),
      body: FutureBuilder<List<UsersInfo>>(
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
            return ListView.builder(
              itemCount: users!.length,
              itemBuilder: (context, index) {
                // Display user information here
                return ListTile(
                    title: Text(users[index].displayName),
                    subtitle: Text(users[index].email),
                    trailing: IconButton(
                    icon: const Icon(Icons.block), // Icon for banning
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm Ban"),
                              content: Text("Are you sure you want to ban ${users[index].displayName}?"),
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
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                      "Ban",
                                      style: TextStyle(
                                      color: Colors.red,
                                      ),
                                    )
                                  ),
                              ],
                            );
                          },
                        );
                      },
                  )
                );
              },
            );
          }
        },
      ),
    );
  }
}
