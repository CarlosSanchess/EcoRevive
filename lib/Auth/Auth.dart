import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth;
  User? currentUser;

  Auth() : _firebaseAuth = FirebaseAuth.instance {
    currentUser = _firebaseAuth.currentUser;
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;
      print('User created successfully: ${user.uid}');
    } catch (e) {
      print('User creation failed: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    return currentUser != null;
  }

  Future<void> updateUserEmail(String email) async {
    await currentUser?.verifyBeforeUpdateEmail(email);
  }

  Future<void> updateUserPassword(String password) async {
    await currentUser?.updatePassword(password);
  }

  Future<String> getUid() async {
    if (currentUser != null) {
      return currentUser!.uid;
    } else {
      throw Exception("No user is currently signed in.");
    }
  }

  Future<void> updatePhotoURL(String? url) async {
    await currentUser?.updatePhotoURL(url);
  }

  Future<String?> getEmail() async {
    return currentUser?.email;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> ChangePassword(String oldPassword, String newPassword) async {
    try {
      // Re-authenticate user with their current credentials
      AuthCredential credential = EmailAuthProvider.credential(email: currentUser!.email!, password: oldPassword);
      await currentUser!.reauthenticateWithCredential(credential);

      // Update the password
      await updateUserPassword(newPassword);
      print('Password changed successfully.');
    } catch (e) {
      print('Failed to change password: $e');
      rethrow;
    }
  }
  Future<String> getEmailByUid(String userId) async {
    //Need Admin SDK
  }
}
