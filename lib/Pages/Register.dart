import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register/Controllers/RegisterLoginControllers.dart';
import 'package:register/Functions/Functions.dart';
import 'package:register/Pages/theme_provider.dart';

class Register extends StatelessWidget {
  final void Function() switchPages;

  Register({super.key, required this.switchPages});

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.getTheme().appBarTheme.backgroundColor,
        leading: IconButton(
          onPressed: switchPages,
          icon: const Icon(Icons.arrow_back_ios_new),
          color: themeProvider.getTheme().appBarTheme.iconTheme!.color,
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
                const SizedBox(height: 100),
                TextContainer(
                  hintText: "E-mail",
                  obscureText: false,
                  icon: const Icon(Icons.mail),
                  textEditingController: usernameController,
                ),
                const SizedBox(height: 15),
                TextContainer(
                  hintText: "Password",
                  obscureText: true,
                  icon: const Icon(Icons.key),
                  textEditingController: passwordController,
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    createPopUp(RegisterLoginControllers(usernameController: usernameController, passwordController: passwordController).signUp(), context);
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
