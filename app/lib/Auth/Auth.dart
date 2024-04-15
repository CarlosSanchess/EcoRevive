import 'package:firebase_auth/firebase_auth.dart';


class Auth{

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<void> createUserWithMailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;
      print('User created successfully: ${user.uid}');
    } catch (e) {
      print('User creation failed: $e');
    }
  }
}