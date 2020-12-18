import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_familly_app/models/user.dart';
import 'package:flutter_familly_app/services/firebaseMethods.dart';

class FirebaseHelper {
  FirebaseMethods _firebaseHelper = FirebaseMethods();

  Future<User> getCurrentUser() => _firebaseHelper.getCurrentUser();
  Future<List<UserModel>> fetchAllUsers(User user) =>
      _firebaseHelper.fetchAllUsers(user);
  Future<List> joinFamily() => _firebaseHelper.joinFamily();
  Future<List> getFamMembers() => _firebaseHelper.getFamMembers();
  // Future<List> getFamCalendar() => _firebaseHelper.getFamilyCalendar();
  Future<bool> isAdmin() => _firebaseHelper.isAdmin();
  Future<bool> isFamilyId() => _firebaseHelper.isFamilyId();
  Future<String> getFID() => _firebaseHelper.getFID();

  //Future<List<Events>> getFamEvents() => _firebaseHelper.getFamEvents();
  bool isEmailVerified(User user) => _firebaseHelper.isEmailVerified(user);
}
