import 'package:flutter/material.dart';
import 'package:register/Auth/LoginOrRegister.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode()); // Hide the keyboard
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 80, right: 80, bottom: 40),
                  child: Image.asset('lib/Imgs/Icon.png'),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Recycling Made Easy",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Building a community !",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return const LoginOrRegister();
                  })),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.lightGreen.shade800,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 120)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
