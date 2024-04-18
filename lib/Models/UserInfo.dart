import 'package:firebase_auth/firebase_auth.dart';
import 'package:register/Auth/Auth.dart';

class UserInfo {
  late String _userID;
  late String _email;
  late String _displayName;

/*
  UserInfo(String userId, String email){
    _userID = Auth().currentUser!.uid;
    _displayName =_getDiplayName(_email);
  };

  String _getDiplayName(Future<String> email) async{

    List<String> parts = email.split('@');
    return parts[0];
  }
*/
}
