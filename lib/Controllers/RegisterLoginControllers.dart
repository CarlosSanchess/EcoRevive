import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:register/Controllers/FireStoreController.dart';

class RegisterLoginControllers {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController? displayNameController;

  const RegisterLoginControllers({
    required this.usernameController,
    required this.passwordController,
    this.displayNameController,
  });

  Future<String> signUp() async {
    var email = usernameController.text;
    var password = passwordController.text;
    var displayName = displayNameController?.text;

    usernameController.clear();
    passwordController.clear();
    displayNameController?.clear();

    var emailValidationResult = acceptableEmail(email);
    if (emailValidationResult != "Ok") {
      return emailValidationResult;
    }

    var passwordValidationResult = acceptablePassword(password);
    if (passwordValidationResult != "Ok") {
      return passwordValidationResult;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      if (displayName != null && displayName.isNotEmpty) {
        await userCredential.user!.updateProfile(displayName: displayName);
      }

      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        FireStoreController().addFCMTokenToCollection(token);
      }

      return "Registered !!";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message ?? "Error in Register";
    } catch (e) {
      return 'Error in Register';
    }
  }

  Future<String> signIn() async {
    var email = usernameController.text;
    var password = passwordController.text;

    usernameController.clear();
    passwordController.clear();

    if (email.isEmpty || password.isEmpty) {
      return 'Need to provide all info!';
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return 'Logged In!!';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Invalid Credentials!';
    } catch (e) {
      return 'Invalid Credentials!';
    }
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
