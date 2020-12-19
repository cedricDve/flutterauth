import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter_familly_app/commons/const.dart';
import 'package:flutter_familly_app/models/calendarModel.dart';
import 'package:flutter_familly_app/models/user.dart';
import 'package:flutter_familly_app/services/auth.dart';
import 'package:flutter_familly_app/models/conversation.dart';
import 'package:flutter_familly_app/models/message.dart';
import 'package:flutter_familly_app/models/famMemberModel.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool isFam;
  List famMembers = List();

  Future<User> getCurrentUser() async {
    User currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<bool> isAdmin() async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    // Get data from Firestore of current user with cuid ->(CurrentUserID)
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(cuid).get();
    return ds.get('isAdmin');
  }

  Future<bool> isFamilyId() async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    // Get data from Firestore of current user with cuid ->(CurrentUserID)
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(cuid).get();
    if (ds.get('fid') != null)
      return true;
    else
      return false;
  }

  Future<String> getFID() async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    // Get data from Firestore of current user with cuid ->(CurrentUserID)
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(cuid).get();
    return ds.get('fid');
  }

  Future<String> getAvatarOfId(String id) async {
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(id).get();
    return ds.get('avatar');
  }

  Future<String> getNameOfId(String id) async {
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(id).get();
    return ds.get('name');
  }

  Future<List<FamMemberModel>> getFamilyAvatars() async {
    FamMemberModel famMemberModel;
    String fID;
    String avatar;
    String name;
    await getFID().then((value) {
      fID = value;
    });
    DocumentSnapshot dsf =
        await _firebaseFirestore.collection("families").doc(fID).get();
    List a = dsf.get('members');
    List<FamMemberModel> listFamModel = List<FamMemberModel>();
    for (var i = 0; i < a.length; i++) {
      getAvatarOfId(a[i]).then((pieter) async {
        await getNameOfId(a[i]).then((jan) {
          name = jan;
          avatar = pieter;
          famMemberModel = FamMemberModel(avatar: avatar, id: name);
          listFamModel.add(famMemberModel);
        });
      });
    }
    return listFamModel;
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

  // fetch all the user from the same family as the currendUser
  Future<List<UserModel>> fetchUsersWithFid() async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    List<UserModel> userList = List<UserModel>();

    DocumentSnapshot ds =
    await _firebaseFirestore.collection("users").doc(cuid).get();

    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection("users")
        .where("fid", isEqualTo: ds.get('fid'))
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != cuid) {
        userList.add(UserModel.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  //create conversation with as input the other user(for one to one conversation)
  Future<String> createConversation(String cuid2) async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    String cid;
    List<String> list1 = [cuid, cuid2];
    List<String> list2 = [cuid2, cuid];

    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(cuid).get();
    String fid = ds.get('fid');

    if (fid != null) {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection("families")
          .doc(fid)
          .collection("conversations")
          .where('members', isEqualTo: list1)
          .get();
      QuerySnapshot querySnapshotSender = await _firebaseFirestore
          .collection("families")
          .doc(fid)
          .collection("conversations")
          .where('memberSender', isEqualTo: list2)
          .get();

      await _firebaseFirestore
          .collection("families")
          .doc(fid)
          .collection("conversations")
          .doc()
          .get()
          .then((value) {
        if (querySnapshot.docs.isEmpty || querySnapshotSender.docs.isEmpty) {
          ConversationModel conversationModel = ConversationModel(
            cid: value.id,
            updateDate: DateTime.now().millisecondsSinceEpoch,
            members: list1,
            memberSender: list2,
          );
          _firebaseFirestore
              .collection("families")
              .doc(fid)
              .collection("conversations")
              .doc(value.id)
              .set(conversationModel.toMap(conversationModel));
          cid = value.id;
        } else {
          cid = querySnapshot.docs.first.id;
        }
      });
      return cid;
    }
  }

  //create a message in the selected conversation withe as input the conversation ID
  Future<void> createMessage(String message, String cid) async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(cuid).get();
    String fid = ds.get('fid');

    if (fid != null) {
      await _firebaseFirestore
          .collection("families")
          .doc(fid)
          .collection("conversations")
          .doc(cid)
          .collection("message")
          .doc()
          .get()
          .then((value) {
        MessageModel messageModel = MessageModel(
          mid: value.id,
          message: message,
          sender: cuid,
          time: DateTime.now().millisecondsSinceEpoch,
        );
        _firebaseFirestore
            .collection("families")
            .doc(fid)
            .collection("conversations")
            .doc(cid)
            .collection("messages")
            .doc(value.id)
            .set(messageModel.toMap(messageModel));
        // if user create a conversation user it take the last time
        _firebaseFirestore
            .collection("families")
            .doc(fid)
            .collection("conversations")
            .doc(cid)
            .update({
          'updateDate': DateTime.now().millisecondsSinceEpoch,
        });
      });
    }
  }

  //create a message in the selected conversation withe as input the conversation ID
  fetchAllMessages(String cid) async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(cuid).get();
    String fid = ds.get('fid');

    if (fid != null) {
      // if user fetch user it take the last time
      _firebaseFirestore
          .collection("families")
          .doc(fid)
          .collection("conversations")
          .doc(cid)
          .update({
        'updateDate': DateTime.now().millisecondsSinceEpoch,
      });
      return _firebaseFirestore
          .collection("families")
          .doc(fid)
          .collection("conversations")
          .doc(cid)
          .collection("messages")
          .orderBy('time')
          .snapshots();
    }
  }

  //create a message in the selected conversation withe as input the conversation ID
  fetchAllConversations() async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(cuid).get();
    String fid = ds.get('fid');

    if (fid != null) {
      //TODO: order by date
      return _firebaseFirestore
          .collection("families")
          .doc(fid)
          .collection("conversations")
          .where("members", arrayContainsAny: [cuid])
          .snapshots();
    }
  }

  //replace the writed message to "message is delete"
  Future<void> deleteMessageForAll(String cid, String mid) async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(cuid).get();
    String fid = ds.get('fid');

    if (fid != null) {
      _firebaseFirestore
          .collection("families")
          .doc(fid)
          .collection("conversations")
          .doc(cid)
          .collection("messages")
          .doc(mid)
          .update({'message': "message delete"});
    }
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

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
}

  bool isEmailVerified(User user) {
    if (user.emailVerified) {
      return true;
    } else
      return false;
  }
}

final eventDBS = DatabaseService<CalendarEvent>(
  AppDBConstants.eventCollection,
  fromDS: (id, data) => CalendarEvent.fromDS(id, data),
  toMap: (event) => event.toMap(),
);

// For Calendar Events
// Using firebase_helpers:

/*

  Future<List<Events>> getFamEvents() async {
    List<Events> famEventsList = List<Events>();
    String fID = await getFID();

    print(fID);
    //get FamEvents
    QuerySnapshot fqs = await _firebaseFirestore
        .collection("families")
        .doc(fID)
        .collection('family_events')
        .get();
    for (var i = 0; i < fqs.docs.length; i++) {
      famEventsList.add(Events.fromMap(fqs.docs[i].data()));
    }
    print(famEventsList);
    return famEventsList;
  }


  //fetch all users in a List (for search) => Passing User : otherwise auth user could find himself ..

  Future<UserModel> fetchUserModel(String currentUser) async {
    UserModel userModel;
    //get all users and store in Querydatasnapshot
    await _firebaseFirestore.collection("users").doc(currentUser.uid).get().then((value) => value.id);
    print( await _firebaseFirestore.collection("users").doc(currentUser.uid).get().then((value) => value.id));
//each user has a user id = firebaseAuth currentUserId
    return userModel;
  }
 

 Future<List> getFamilyCalendar() async {
    List a = await getFamMembers();
    print(a);

    // Get data from Firestore of current user with cuid ->(CurrentUserID)
    List userList = List<CalendarEvent>();
    //get all users and store in Querydatasnapshot
    QuerySnapshot querySnapshot =
        await _firebaseFirestore.collection("calendar_events").get();
//each user has a user id = firebaseAuth currentUserId
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      Map<String, dynamic> s = querySnapshot.docs[i].data();
      for (String key in s.keys) {
        if (a.contains(s[key])) userList.add(querySnapshot.docs[i].id);
      }
      // userList.add(UserModel.fromMap(querySnapshot.docs[i].data()));
    }
    return userList;
  }


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
