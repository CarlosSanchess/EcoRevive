import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register/Controllers/RegisterLoginControllers.dart';
import 'package:register/Functions/Functions.dart';
import 'package:register/Pages/theme_provider.dart';

class Register extends StatelessWidget {
  Register({super.key});

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Theme.of(context).appBarTheme.iconTheme!.color,
        ),
      ),
      backgroundColor: themeProvider.getTheme().scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(
                  Icons.person_outlined,
                  size: 100,
                  color: themeProvider.getTheme().brightness == Brightness.light
                      ? Colors.grey[300]
                      : themeProvider.getTheme().iconTheme.color,
                ),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Create New Account',
                  style: TextStyle(
                    fontSize: 18,
                    color: themeProvider.getTheme().textTheme.displayMedium!.color,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 30),
                TextContainer(
                  hintText: "E-mail",
                  obscureText: false,
                  icon: const Icon(Icons.mail),
                  textEditingController: usernameController,
                ),
                const SizedBox(height: 15),
                TextContainer(
                  hintText: "Display Name",
                  obscureText: false,
                  icon: const Icon(Icons.person),
                  textEditingController: displayNameController,
                ),
                const SizedBox(height: 15),
                TextContainer(
                  hintText: "Password",
                  obscureText: true,
                  icon: const Icon(Icons.lock),
                  textEditingController: passwordController,
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () async {
                    String result = await RegisterLoginControllers(
                      usernameController: usernameController,
                      passwordController: passwordController,
                      displayNameController: displayNameController,
                    ).signUp();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(result),
                        actions: [
                          TextButton(
                            onPressed: () {
                              print(result);
                              if (result == "Registered !!") {
                                Navigator.pop(context, 'OK');
                                Navigator.pop(context);
                              } else {
                                Navigator.pop(context, 'OK');
                              }
                            },
                            child: const Text('OK'),
                          )
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: themeProvider.getTheme().primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
