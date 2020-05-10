
class User {
  String displayName;
  String email;
  String password;
//  String sugars;
//  int strength;
  User();
}

class UserData {
  final String uid;
  final String sugars;
  final String name;
  final int strength;
  UserData({this.uid, this.sugars, this.name, this.strength});
}