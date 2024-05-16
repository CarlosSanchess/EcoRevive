

class UsersInfo { //Consider UserInfo, and using prefixs TODO
  late String _userID;
  late String _email;
  late String _displayName;

  UsersInfo(String userID, String email, String displayName) {
    _userID = userID;
    _email = email;
    _displayName = displayName;
  }

  String get userID => _userID;

  String get email => _email;

  String get displayName => _displayName;
}
