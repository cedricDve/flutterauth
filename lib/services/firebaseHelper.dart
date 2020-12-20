import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_familly_app/models/user.dart';
import 'package:flutter_familly_app/models/famMemberModel.dart';

import 'package:flutter_familly_app/services/firebaseMethods.dart';

class FirebaseHelper {
  FirebaseMethods _firebaseHelper = FirebaseMethods();

  Future<User> getCurrentUser() => _firebaseHelper.getCurrentUser();
  Future<List<UserModel>> fetchAllUsers(User user) =>
      _firebaseHelper.fetchAllUsers(user);

  Future<List<UserModel>> fetchUsersWithFid() =>
      _firebaseHelper.fetchUsersWithFid();

  Future<String> createConversation(String cuid2) =>
      _firebaseHelper.createConversation(cuid2);

  Future<void> createMessage(String message, String cid) =>
      _firebaseHelper.createMessage(message, cid);

  fetchAllMessages(String cid) => _firebaseHelper.fetchAllMessages(cid);

  fetchAllConversations() => _firebaseHelper.fetchAllConversations();

  Future<void> deleteMessageForAll(String cid, String mid) =>
      _firebaseHelper.deleteMessageForAll(cid, mid);

  Future<void> deleteConversation(String cid) =>
      _firebaseHelper.deleteConversation(cid);

  Future<List> joinFamily() => _firebaseHelper.joinFamily();
  Future<List> getFamMembers() => _firebaseHelper.getFamMembers();
  // Future<List> getFamCalendar() => _firebaseHelper.getFamilyCalendar();
  Future<bool> isAdmin() => _firebaseHelper.isAdmin();
  Future<bool> isFamilyId() => _firebaseHelper.isFamilyId();
  Future<String> getFID() => _firebaseHelper.getFID();
  Future<void> resetPassword(String mail) =>
      _firebaseHelper.resetPassword(mail);
  //Future<List<Events>> getFamEvents() => _firebaseHelper.getFamEvents();
  bool isEmailVerified(User user) => _firebaseHelper.isEmailVerified(user);

  Future<List<FamMemberModel>> getFamilyAvatars() =>
      _firebaseHelper.getFamilyAvatars();

  Future<String> getFamCallCode(String id) =>
      _firebaseHelper.getFamCallCode(id);

  // Gamify
  Future<int> countFamPost() => _firebaseHelper.countFamPost();
  Future<int> countFamImages() => _firebaseHelper.countFamImages();
  Future<int> countCalendarCU() => _firebaseHelper.countCalendarCU();
  Future<int> countFaq() => _firebaseHelper.countFaq();
  Future<void> deleteUserData() => _firebaseHelper.deleteUserData();
}
