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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ModeratorHome()),
            );
          },
        ),
        title: const Text('Users'),
      ),
      body: Column(
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
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Active Users',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(users[index].displayName),
                                subtitle: Text(users[index].email),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.block), // Icon for banning
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Confirm Soft"),
                                              content: Text("Are you sure you want to soft Ban ${users[index].displayName}?"),
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
                                      icon: const Icon(Icons.close), // Icon for close
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Confirm Ban"),
                                              content: Text("Are you sure you want to ban ${users[index].displayName}?(It can´t be reverted)"),
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
                                                    );                                                  },
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
          Expanded(
            child: FutureBuilder<List<UsersInfo>>(
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
                    return const Center(
                      child: Text('No disabled users.'),
                    );
                  } else {
                    return Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Disabled Users',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(users[index].displayName),
                                subtitle: Text(users[index].email),
                                trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.check_box), // Icon for banning
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
                                                    UserController(userInfo: users[index]).disableUser();
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
    );
  }
}
