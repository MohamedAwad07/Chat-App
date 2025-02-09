
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUserInfo {
  final String username;
  final String email;
  final String uid;

  CurrentUserInfo({required this.username, required this.email, required this.uid});

  factory CurrentUserInfo.fromJson(User json, {required String username}) {
    return CurrentUserInfo(username: username, email: json.email!, uid: json.uid);
  }
}
