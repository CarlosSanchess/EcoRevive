import 'package:register/Controllers/RegisterLoginControllers.dart';
import 'package:flutter_test/flutter_test.dart';



void main(){
  group('Password Validation Tests', () {
    test('Empty password test', () {
      expect(acceptablePassword(''), equals("Password cannot be empty."));
    });

    test('Short password test', () {
      expect(acceptablePassword('abcd'), equals("Password needs to be 8 characters minimum."));
    });

    test('Long password test', () {
      expect(acceptablePassword('ABccccasda123@adasasaasd'), equals("Password needs to have less than 20 characters."));
    });

    test('Password without number test', () {
      expect(acceptablePassword('Password'), equals("Password needs to have at least one number."));
    });

    test('Password without uppercase letter test', () {
      expect(acceptablePassword('password123'), equals("Password needs to have at least one uppercase letter."));
    });

    test('Password without special character test', () {
      expect(acceptablePassword('Password123'), equals("Password needs to have at least one special character."));
    });

    test('Valid password test', () {
      expect(acceptablePassword('Password123!'), equals("Ok"));
    });
  });

  group('Email Validation Tests', () {
    test('Empty email test', () {
      expect(acceptableEmail(''), equals("Email cannot be empty."));
    });

    test('Invalid email test', () {
      expect(acceptableEmail('invalid_email'), equals("Please enter a valid email address."));
    });

    test('Valid email test', () {
      expect(acceptableEmail('test@example.com'), equals("Ok"));
    });
  });
/*
  test("Register an existing email", () async{

    TextEditingController emailController = TextEditingController(text: 'rebeloteste12@gmail.com'); //Existing Email
    TextEditingController passwordController = TextEditingController(text: 'Password123!'); //Valid Password
    RegisterLoginControllers registerLoginControllers = RegisterLoginControllers(usernameController: emailController, passwordController: passwordController);
    expect(await registerLoginControllers.signUp(),equals("The account already exists for that email."));
  });
*/
}