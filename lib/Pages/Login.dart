import 'package:flutter/material.dart';
import 'package:register/Functions/Functions.dart';
import 'package:register/Controllers/RegisterLoginControllers.dart';
import 'package:register/Auth/Auth.dart';
import 'package:register/Pages/Home.dart';

class Login extends StatefulWidget {
  final void Function() switchPages;
  const Login({Key? key, required this.switchPages}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(
                  Icons.person_outlined,
                  size: 100,
                  color: theme.brightness == Brightness.light ? Colors.grey[300] : theme.iconTheme.color,
                ),
                const Text(
                  'Welcome, Back!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.brightness == Brightness.light ? theme.textTheme.bodyText1!.color : theme.textTheme.titleMedium!.color,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 50),
                TextContainer(
                  hintText: "UserName",
                  obscureText: false,
                  icon: const Icon(Icons.mail),
                  textEditingController: usernameController,
                ),
                const SizedBox(height: 15),
                TextContainer(
                  hintText: "Password",
                  obscureText: true,
                  icon: const Icon(Icons.lock),
                  textEditingController: passwordController,
                ),
                GestureDetector(
                  onTap: () {
                    // Implement your forgot password logic here
                    // For example, you can navigate to a forgot password screen
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 27.5),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () async {
                    Future<String> aux = RegisterLoginControllers(
                      usernameController: usernameController,
                      passwordController: passwordController,
                    ).signIn();
                    if(await aux == "Logged In!!"){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    }else{
                        createPopUp(aux, context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: theme.primaryColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: theme.textTheme.titleMedium!.color),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.facebook,
                      size: 36,
                      color: theme.brightness == Brightness.light ? Colors.blueAccent : Colors.white,
                    ),
                    SizedBox(width: 25),
                    Icon(
                      Icons.apple,
                      size: 36,
                      color: theme.brightness == Brightness.light ? Colors.black : Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.switchPages,
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
