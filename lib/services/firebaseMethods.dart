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

  Future<String> getFamCallCode(String id) async {
    return FirebaseFirestore.instance.collection("calender_events").doc(id).id;
  }

  Future<bool> isAdmin() async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    // Get data from Firestore of current user with cuid ->(CurrentUserID)
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(cuid).get();
    return ds.get('isAdmin') as bool;
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
    return ds.get('fid') as String;
  }

  Future<String> getAvatarOfId(String id) async {
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(id).get();
    return ds.get('avatar') as String;
  }

  Future<String> getNameOfId(String id) async {
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(id).get();
    return ds.get('name') as String;
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
    List a = dsf.get('members') as List<dynamic>;
    List<FamMemberModel> listFamModel = List<FamMemberModel>();
    for (var i = 0; i < a.length; i++) {
      getAvatarOfId(a[i] as String).then((pieter) async {
        await getNameOfId(a[i] as String).then((jan) {
          name = jan;
          avatar = pieter;
          famMemberModel =
              FamMemberModel(avatar: avatar, id: a[i], name: name, fid: fID);
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
    String fid = ds.get('fid') as String;

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
              .set(conversationModel.toMap(conversationModel) as Map<String, dynamic>);
          cid = value.id;
        } else {
          cid = querySnapshot.docs.first.id;
        }
      });
      return cid;

  }

  //create a message in the selected conversation withe as input the conversation ID
  Future<void> createMessage(String message, String cid) async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(cuid).get();
    String fid = ds.get('fid') as String;


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
            .set(messageModel.toMap(messageModel) as Map<String, dynamic>);
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

  //create a message in the selected conversation withe as input the conversation ID
  fetchAllConversations() async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    DocumentSnapshot ds =
    await _firebaseFirestore.collection("users").doc(cuid).get();
    String fid = ds.get('fid') as String;

    if (fid != null) {
      //TODO: order by date
      return _firebaseFirestore
          .collection("families")
          .doc(fid)
          .collection("conversations")
          .where("members", arrayContainsAny: [cuid]).snapshots();
    }
  }

  //create a message in the selected conversation withe as input the conversation ID
  fetchAllMessages(String cid) async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(cuid).get();
    String fid = ds.get('fid') as String;

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
          .orderBy('time', descending: true)
          .snapshots();
    }
  }

  //replace the writed message to "message is delete"
  Future<void> deleteConversation(String cid) async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    DocumentSnapshot ds =
    await _firebaseFirestore.collection("users").doc(cuid).get();
    String fid = ds.get('fid') as String;

    if (fid != null) {
      _firebaseFirestore
          .collection("families")
          .doc(fid)
          .collection("conversations")
          .doc(cid)
          .delete();
    }
  }

  //replace the writed message to "message is delete"
  Future<void> deleteMessageForAll(String cid, String mid) async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(cuid).get();
    String fid = ds.get('fid') as String;

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
    // Get the current user ID => get doc snapshot of current user from Firestore
    String cuid = Auth(auth: _auth).currentUser.uid;
    DocumentSnapshot ds =
        await _firebaseFirestore.collection("users").doc(cuid).get();
    // Get data from Firestore of family with FID of cuid
    DocumentSnapshot dsf = await _firebaseFirestore
        .collection("families")
        .doc(ds.get('fid') as String)
        .get();
    //List for the family request
    List a = dsf.get('membersRequest') as List<dynamic>;
    //check family state: family-id and check if user is in a family
    if (ds.get('fid') == null)
      isFam = false;
    //check if user is admin
    else if (ds.get('isAdmin') as bool && a.length >= 1) {
      print("A USER WANA JOIN THE FAM");
      //status user: isJoin ? => get user id and prevent the admin
      bool isJoin = true;
      String juid = a[0] as String;
      // Get data from Firestore of user that like to join the family
      DocumentSnapshot jds =
          await _firebaseFirestore.collection("users").doc(juid).get();
      //List of data from the joining user
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
        .doc(ds.get('fid') as String)
        .get();
    List a = dsf.get('members') as List<dynamic>;
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

  //-------Gamify
  Future<int> countFamPost() async {
    String fID;
    int countPosts;
    await getFID().then((value) {
      fID = value;
    });
    await _firebaseFirestore
        .collection('families')
        .doc(fID)
        .collection('thread')
        .get()
        .then((snapshot) {
      countPosts = snapshot.size;
    });
    return countPosts;
  }

  Future<int> countFamImages() async {
    String fID;
    int countImages;
    await getFID().then((value) {
      fID = value;
    });
    await _firebaseFirestore
        .collection('families')
        .doc(fID)
        .collection('imageURLs')
        .get()
        .then((snapshot) {
      countImages = snapshot.size;
    });
    return countImages;
  }

  Future<int> countCalendarCU() async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    int countCalendarCU;
    await _firebaseFirestore
        .collection('calendar_events')
        .where('user_id', isEqualTo: cuid)
        .get()
        .then((snapshot) {
      countCalendarCU = snapshot.size;
    });
    return countCalendarCU;
  }

  Future<int> countFaq() async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    const QUESTIONS = 3;
    int countFaq = 0;
    for (var i = 0; i < QUESTIONS; i++)
      await _firebaseFirestore
          .collection('faq')
          .doc("question$i")
          .collection('faqComments')
          .where("user_id", isEqualTo: cuid)
          .get()
          .then((value) {
        if (value != null) countFaq += value.size;
      });
    return countFaq;
  }
//---------------------End Gamify

//Delete data of user

  Future<void> deleteUserData() async {
    String cuid = Auth(auth: _auth).currentUser.uid;
    String fid;
    await getFID().then((value) async {
      fid = value;

      await _firebaseFirestore.collection("families").doc(fid).collection("conversations").where("members", arrayContainsAny: [cuid]).get().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      await _firebaseFirestore.collection("families").doc(fid).collection("thread").where('userId', isEqualTo: cuid).get().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      await _firebaseFirestore.collection("families").doc(fid).collection("thread").where('userId', isEqualTo: cuid).get().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      DocumentSnapshot ds =
      await _firebaseFirestore.collection("users").doc(cuid).get();
      CollectionReference collectionReference = _firebaseFirestore.collection("families").doc(fid).collection("thread");
      await collectionReference.get().then((documents){
        for(var i = 0; i < documents.size; i++){

          documents.docs.forEach((elementOfDocuments) async {
            if(elementOfDocuments.get('postCommentCount') != 0){
            await collectionReference.doc(elementOfDocuments.id).collection("comment").where('userName', isEqualTo: ds.get('name')).get().then((snapshot){
              for(DocumentSnapshot doc in snapshot.docs){
                doc.reference.delete();
              }
            });
            }
          });
        }
      });


      await _firebaseFirestore.collection("families").doc(fid).update({'members': FieldValue.arrayRemove([cuid])});

      await _firebaseFirestore.collection("users").where('uid', isEqualTo: cuid).get().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
  });
}
}

// For Calendar Events: Using firebase_helpers:
final eventDBS = DatabaseService<CalendarEvent>(
  AppDBConstants.eventCollection,
  fromDS: (id, data) => CalendarEvent.fromDS(id, data),
  toMap: (event) => event.toMap(),
);

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
