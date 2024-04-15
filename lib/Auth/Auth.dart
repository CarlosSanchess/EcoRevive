import 'package:firebase_auth/firebase_auth.dart';


class Auth{

  final FirebaseAuth firebaseAuth;
  late User? currentUser;

  Auth() : firebaseAuth = FirebaseAuth.instance {
    currentUser = firebaseAuth.currentUser;
  }

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

  Future<bool> isLoggedIn() async {
    if (currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateUserEmail(String email) async{
    currentUser?.verifyBeforeUpdateEmail(email);
  }
  Future<void> updateUserPassWord(String password) async{
    currentUser?.updatePassword(password);
  }
  Future<String> getUid() async{
    return  currentUser!.uid;
  }
  Future<void> updatePhotoURL(String? url) async{
    currentUser?.updatePhotoURL(url);
  }
  Future<String?> getEmail() async{
    return currentUser?.email;
  }
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
