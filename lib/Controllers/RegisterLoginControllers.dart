import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterLoginControllers {
  final TextEditingController passwordController;
  final TextEditingController usernameController;

  const RegisterLoginControllers({
    required this.usernameController,
    required this.passwordController
  });

  Future<String> signUp() async {
    var email = usernameController.text;
    var password = passwordController.text;

    usernameController.clear();
    passwordController.clear();

    if(acceptablePassword(password) != "Ok"){
      return acceptablePassword(password);
    }
    if(acceptableEmail(email) != "Ok")
    {
      return acceptableEmail(email);
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return 'Error in Register';
    }
    return "Registered !!";
  }

  Future<String> signIn() async{

    String email = usernameController.text;
    String password = passwordController.text;
    if(email.isEmpty || password.isEmpty){
      return 'Need to provide all info!';
    }
    usernameController.clear();
    passwordController.clear();

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } catch (e) {
      // Sign in fails
      return 'Invalid Credentials!';
    }
    return 'Logged In!!';
  }
}

String acceptablePassword(String str) {
    bool containsUppercase = str.contains(RegExp(r'[A-Z]'));
    bool containsNumber = str.contains(RegExp(r'[0-9]'));
    bool containsSpecialChar = str.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (str.isEmpty) {
      return "Password cannot be empty.";
    }

    if (str.length < 8) {
      return "Password needs to be 8 characters minimum.";
    }

    if (!containsNumber) {
      return "Password needs to have at least one number.";
    }

    if (!containsUppercase) {
      return "Password needs to have at least one uppercase letter.";
    }

    if (!containsSpecialChar) {
      return "Password needs to have at least one special character.";
    }

    if (str.length > 20) {
      return "Password needs to have less than 20 characters.";
    }

  return "Ok";
}

String acceptableEmail(String email) {
  bool isValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

  if (email.isEmpty) {
    return "Email cannot be empty.";
  }

  if (!isValidEmail) {
    return "Please enter a valid email address.";
  }

  return "Ok";
}



