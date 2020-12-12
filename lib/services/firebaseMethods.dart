import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter_familly_app/commons/const.dart';
import 'package:flutter_familly_app/models/calendarModel.dart';

import 'package:flutter_familly_app/models/user.dart';

import 'package:flutter_familly_app/services/auth.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool isFam;
  List famMembers = List();

  Future<User> getCurrentUser() async {
    // User currentUser = await _auth.currentUser;
    User currentUser = await _auth.currentUser;
    return currentUser;
  }

  //fetch all users in a List (for search) => Passing User : otherwise auth user could find himself ..
  Future<List<UserModel>> fetchAllUsers(User currentUser) async {
    List<UserModel> userList = List<UserModel>();
    //get all users and store in Querydatasnapshot
    QuerySnapshot querySnapshot =
        await _firebaseFirestore.collection("users").get();
//each user has a user id = firebaseAuth currentUserId
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(UserModel.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  Future<List> joinFamily() async {
    // Get the current user ID
    String cuid = Auth(auth: _auth).currentUser.uid;
    // Get data from Firestore of current user with cuid ->(CurrentUserID)
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(cuid).get();
    // Get data from Firestore of family with FID of cuid
    DocumentSnapshot dsf = await _firebaseFirestore
        .collection("families")
        .doc(ds.get('fid'))
        .get();

    List a = dsf.get('membersRequest');
    if (ds.get('fid') == null)
      isFam = false;
    else if (ds.get('isAdmin') && a.length >= 1) {
      print("A USER WANA JOIN THE FAM");

      bool isJoin = true;

      String juid = a[0];

      DocumentSnapshot jds =
          await _firebaseFirestore.collection("users").doc(juid).get();

      List data = List();
      data.add(jds.get('name'));
      data.add(isJoin);
      data.add(isFam);
      return data;
    }
    return List();
  }

  Future<List> getFamMembers() async {
    // Get the current user ID
    String cuid = Auth(auth: _auth).currentUser.uid;
    // Get data from Firestore of current user with cuid ->(CurrentUserID)
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(cuid).get();
    // Get data from Firestore of family with FID of cuid
    DocumentSnapshot dsf = await _firebaseFirestore
        .collection("families")
        .doc(ds.get('fid'))
        .get();
    List a = dsf.get('members');
    if (a.length >= 1) {
      for (var i = 0; i < a.length; i++) {
        famMembers.add(a[i]);
      }
      return famMembers;
    }
    return List();
  }

/*
  //fetch all users in a List (for search) => Passing User : otherwise auth user could find himself ..
  Future<UserModel> fetchUserModel(String currentUser) async {
    UserModel userModel;
    //get all users and store in Querydatasnapshot
    await _firebaseFirestore.collection("users").doc(currentUser.uid).get().then((value) => value.id);
    print( await _firebaseFirestore.collection("users").doc(currentUser.uid).get().then((value) => value.id));
//each user has a user id = firebaseAuth currentUserId
    return userModel;
  }
 */

/*
  Future<void> addDataToFirestore(User currentUser) async {
    user = UserModel(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      username: username,
      birthday: birthday,
      avatar: currentUser.photoURL,
    );
    _firebaseFirestore.collection("users").doc().set(user.toMap(user));
  }*/
}

// For Calendar Events
// Using firebase_helpers:
final eventDBS = DatabaseService<CalendarEvent>(
  AppDBConstants.eventCollection,
  fromDS: (id, data) => CalendarEvent.fromDS(id, data),
  toMap: (event) => event.toMap(),
);
