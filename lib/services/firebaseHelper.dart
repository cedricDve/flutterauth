import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_familly_app/models/user.dart';
import 'package:flutter_familly_app/services/firebaseMethods.dart';

class FirebaseHelper {
  FirebaseMethods _firebaseHelper = FirebaseMethods();

  Future<User> getCurrentUser() => _firebaseHelper.getCurrentUser();
  Future<List<UserModel>> fetchAllUsers(User user) =>
      _firebaseHelper.fetchAllUsers(user);
}
