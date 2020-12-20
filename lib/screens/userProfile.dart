import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/Animation/FadeAnimation.dart';
import 'package:flutter_familly_app/commons/const.dart';
import 'package:flutter_familly_app/profileUtils/custom_clipper.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:flutter_familly_app/subViews/changeUserIcon.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_familly_app/services/auth.dart';
import 'introductionScreen.dart';
import 'Choose.dart';
import 'faqPage.dart';
import 'package:flutter_familly_app/models/famMemberModel.dart';

DocumentSnapshot ds;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
String fid;

class UserProfile extends StatefulWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final MyProfileData myData;
  final ValueChanged<MyProfileData> updateMyData;
  UserProfile({this.myData, this.updateMyData});
  @override
  State<StatefulWidget> createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> {
  bool isJoin = false;
  bool isAdmin = false;
  bool isFam;
  String joinUsername;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  String _myThumbnail;
  DocumentSnapshot ds;
  DocumentSnapshot dsf;
  String _myName;
  String famName;
  String _mystatus;
  String cuid;
  List a;

  //Gamify
  List badges = List();
  int countFamPosts;
  int countFamImages;
  int countCalendarCU;
  int countFaq;

  List<FamMemberModel> listFamModel = List<FamMemberModel>();
  @override
  void initState() {
    super.initState();
    _firebaseHelper.isAdmin().then((value) {
      setState(() {
        isAdmin = value;
      });
    });
    _firebaseHelper.joinFamily().then((List list) {
      if (list.isNotEmpty)
        setState(() {
          joinUsername = list[0];
          isJoin = list[1];
          isFam = list[2];
          print(list);
        });
    });
    _firebaseHelper.getFamilyAvatars().then((List<FamMemberModel> value) {
      setState(() {
        listFamModel = value;
      });
    });
    initF();
    //Gamify
    _firebaseHelper.countFamPost().then((value) {
      setState(() {
        countFamPosts = value;
        badges.add(countFamPosts);
      });
    });
    _firebaseHelper.countFamImages().then((value) {
      setState(() {
        countFamImages = value;
        badges.add(countFamImages);
      });
    });
    _firebaseHelper.countCalendarCU().then((value) {
      setState(() {
        countCalendarCU = value;
        badges.add(countCalendarCU);
      });
    });
    _firebaseHelper.countFaq().then((value) {
      setState(() {
        countFaq = value;
        badges.add(countFaq);
      });
    });
  }

  void initF() async {
    cuid = await _firebaseHelper.getCurrentUser().then((user) => user.uid);
    ds = await firestore.collection("users").doc(cuid).get();
    dsf = await firestore.collection("families").doc(ds.get('fid')).get();
  }

  void getCurrentUserData() async {
    bool currentStatus;
    cuid = await _firebaseHelper.getCurrentUser().then((user) => user.uid);
    ds = await _firestore.collection("users").doc(cuid).get();

    _myName = ds.get("name");
    _myThumbnail = ds.get("avatar");
    currentStatus = ds.get("isAdmin");
    fid = ds.get('fid');
    if (currentStatus == false) {
      _mystatus = "Member";
    } else if (currentStatus == true) {
      _mystatus = "Owner";
    }
    DocumentSnapshot fds =
        await firestore.collection("families").doc(fid).get();
    setState(() {
      famName = fds.get('fname');
    });
  }

  Future deleteUser() async {
    try {
      User user = await _firebaseHelper.getCurrentUser();
      user.delete();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUserData();
    print(countFamPosts);
    return SingleChildScrollView(
      child: Container(
        height: (isAdmin) ? 1300 : 1200,
        child: Stack(
          children: <Widget>[
            Container(),
            ClipPath(
                clipper: MyCustomClipper(),
                child: FadeAnimation(
                  1.5,
                  Container(
                    height: 300.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/layer.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )),
            Align(
              alignment: Alignment(0, 1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 80,
                        width: 80,
                        child: Column(
                          children: <Widget>[
                            FadeAnimation(
                              1.5,
                              GestureDetector(
                                  child: Container(
                                      width: 80,
                                      height: 80,
                                      child: FadeAnimation(
                                          1.5,
                                          (_myThumbnail == null)
                                              ? const Text("")
                                              : Image.asset(
                                                  'assets/images/$_myThumbnail'))),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          ChangeUserIcon('$_myThumbnail'),
                                      barrierDismissible: true,
                                    ).then((newMyThumbnail) {
                                      _updateMyData(_myName, newMyThumbnail);
                                    });
                                  }),
                            )
                          ],
                        )),
                  ),
                  GestureDetector(
                      onTap: () {
                        _showDialog();
                      },
                      child: FadeAnimation(
                          1.5,
                          Text(
                            '$_myName',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ))),
                  FadeAnimation(
                    1.5,
                    Text(
                      '$_mystatus',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const Text("Family Awards"),
                  new SizedBox(
                    height: 120.0,
                    width: double.infinity,
                    child: new ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listFamModel.length,
                        itemBuilder: (BuildContext context, int index) =>
                            new Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  new Container(
                                      width: 80,
                                      height: 80,
                                      child: GestureDetector(
                                        child: new Image.asset(
                                            'assets/images/${listFamModel[index].avatar}'),
                                        onLongPress: () async {
                                          _showNotificationAdmin(
                                              listFamModel[index].name,
                                              listFamModel[index].id);
                                        },
                                      )),
                                  new Container(
                                    child: new Text(listFamModel[index].name) ??
                                        Text(""),
                                  )
                                ],
                              ),
                            )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: FadeAnimation(
                        1.5,
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 21.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.group,
                                  size: 40.0,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(width: 24.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    "Family ID: $fid",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Text(
                                      "$famName",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.0),
                                ],
                              ),
                            ],
                          ),
                        ))),
                  ),
                  (isAdmin)
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: FadeAnimation(
                              1.5,
                              Card(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 21.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        _showNotification();
                                      },
                                      icon: (isJoin)
                                          ? Icon(
                                              Icons.notification_important,
                                              color: Colors.red,
                                            )
                                          : Icon(Icons.notification_important),
                                    ),
                                    SizedBox(width: 24.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        (isJoin)
                                            ? Text(
                                                "New Family Request",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              )
                                            : Text(
                                                "No Request",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                        SizedBox(height: 4.0),
                                        /* Text(
                                    '$fid',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12.0,
                                    ),
                                  ),*/
                                      ],
                                    ),
                                  ],
                                ),
                              ))),
                        )
                      : SizedBox(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: FadeAnimation(
                        1.5,
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 21.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) => IntroScreen()),
                                    );
                                  },
                                  icon: Icon(Icons.help,
                                      color: Colors.blue[200])),
                              SizedBox(width: 24.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    "Getting Started With Fami",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                ],
                              ),
                            ],
                          ),
                        ))),
                  ),
                  new SizedBox(
                    height: 200.0,
                    width: double.infinity,
                    child: new ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: badges.length, // 4 badges :
                        itemBuilder: (BuildContext context, int index) =>
                            new Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  new Container(
                                    padding: const EdgeInsets.only(top: 8),
                                    height: 120,
                                    width: 170,
                                    child: Badge(
                                      animationType: BadgeAnimationType.scale,
                                      badgeContent: Image.asset(
                                        (badges[index] < 20)
                                            ? 'assets/images/troph3.png'
                                            : (badges[index] <= 50)
                                                ? 'assets/images/troph2.png'
                                                : (badges[index] <= 100)
                                                    ? 'assets/images/troph1.png'
                                                    : 'assets/images/troph4.png',
                                        height: 60,
                                      ),
                                      badgeColor: Colors.green[200],
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/gamify$index.png',
                                            height: 100,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    height: 50,
                                    child: Column(
                                      children: [
                                        Text(
                                          (badges[index] < 20)
                                              ? "Level 1"
                                              : (badges[index] < 50)
                                                  ? "Level 2"
                                                  : (badges[index] < 100)
                                                      ? "Level 3"
                                                      : "Master-Level",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          "Posted # ${badges[index].toString()}" ??
                                              "0",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: FadeAnimation(
                        1.5,
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 21.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) => FaqPage()),
                                    );
                                  },
                                  icon: Icon(Icons.help,
                                      color: Colors.blue[200])),
                              SizedBox(width: 24.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    "Help / FAQ",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                ],
                              ),
                            ],
                          ),
                        ))),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: FadeAnimation(
                        1.5,
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 21.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () async {
                                    await Auth(auth: widget.auth).signOut();
                                  },
                                  icon: Icon(Icons.exit_to_app,
                                      color: Colors.red)),
                              SizedBox(width: 24.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    "Log Out",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                ],
                              ),
                            ],
                          ),
                        ))),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: FadeAnimation(
                        1.5,
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 21.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () async {
                                    //delete user
                                    await deleteUser();
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red)),
                              SizedBox(width: 24.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    "Delete My Account",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                ],
                              ),
                            ],
                          ),
                        ))),
                  )
                ],
              ),
            ),
            //TopBar(),
          ],
        ),
      ),
    );
  }

  Future<void> _updateMyData(String newName, String newThumbnail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('myName', newName);
    prefs.setString('myThumbnail', newThumbnail);
    setState(() {
      if (newThumbnail == null) {
        showDialog(
          context: context,
          builder: (context) => ChangeUserIcon('$_myThumbnail'),
          barrierDismissible: true,
        ).then((newMyThumbnail) {
          _updateMyData(_myName, newMyThumbnail);
        });
        Fluttertoast.showToast(msg: "Please select a picture !");
      } else {
        _myThumbnail = newThumbnail;
        _myName = newName;
        //push data to db
        _firestore
            .collection("users")
            .doc(cuid)
            .update({'avatar': _myThumbnail});
        _firestore.collection("users").doc(cuid).update({'name': _myName});
      }
    });
    MyProfileData newMyData =
        MyProfileData(myName: newName, myThumbnail: newThumbnail);
    widget.updateMyData(newMyData);
  }

  void updateJoinMember() async {
    setState(() {
      a = dsf.get('membersRequest');
    });
    await FirebaseFirestore.instance
        .collection("families")
        .doc(ds.get('fid'))
        .update({
      'members': FieldValue.arrayUnion([a[0]])
    });
    // set joined user to isFamily true
    await FirebaseFirestore.instance
        .collection("users")
        .doc(a[0])
        .update({'isFamily': true});

    //delete from membersRequest
    await FirebaseFirestore.instance
        .collection("families")
        .doc(ds.get('fid'))
        .update({
      'membersRequest': FieldValue.arrayRemove([a[0]])
    });
  }

  void _showDialog() async {
    TextEditingController _changeNameTextController = TextEditingController();
    await showDialog(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(10.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Type your other nick name',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    hintText: 'ex) loydkim',
                    icon: Icon(Icons.edit)),
                controller: _changeNameTextController,
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('SUBMIT'),
              onPressed: () {
                _updateMyData(_changeNameTextController.text, _myThumbnail);
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  void _showNotification() async {
    await showDialog(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: (isJoin)
                  ? new Text(joinUsername + "would like to join the family !")
                  : new Text("No Notifications ..."),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('ACCEPT'),
              onPressed: () async {
                //update  member
                updateJoinMember();

                setState(() {
                  isJoin = false;
                });
                Navigator.pop(context);
              }),
          //admin declines a user
          new FlatButton(
              child: const Text('DECLINE'),
              onPressed: () async {
                // set joined user to isFamily false
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(a[0])
                    .update({'isFamily': false});

                //delete from membersRequest
                await FirebaseFirestore.instance
                    .collection("families")
                    .doc(ds.get('fid'))
                    .update({
                  'membersRequest': FieldValue.arrayRemove([a[0]])
                });
                setState(() {
                  isJoin = false;
                });
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Later'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  void _showNotificationAdmin(String userName, String userId) async {
    await showDialog(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: Text(
                  "As Admin you can set a member to Admin or Delete a member"),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: Text('SET $userName TO ADMIN'),
              onPressed: () async {
                //update  member
                firestore
                    .collection("users")
                    .doc(userId)
                    .update({'isAdmin': true});
                Fluttertoast.showToast(msg: "$userName setted to ADMIN !");
                Navigator.pop(context);
              }),
          //admin declines a user
          new FlatButton(
              child: Text('DELETE $userName FROM FAMILY'),
              onPressed: () async {
                await firestore
                    .collection("users")
                    .doc(userId)
                    .update({'isFamily': false});
                await firestore
                    .collection("users")
                    .doc(userId)
                    .update({'fid': FieldValue.delete()});
                await firestore.collection("families").doc(fid).update({
                  'members': FieldValue.arrayRemove([userId])
                });
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Later'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
