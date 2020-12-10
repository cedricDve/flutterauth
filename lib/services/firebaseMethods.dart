import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_familly_app/models/user.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

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
