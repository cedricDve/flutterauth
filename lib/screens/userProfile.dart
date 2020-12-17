import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/Animation/FadeAnimation.dart';
import 'package:flutter_familly_app/commons/const.dart';
import 'package:flutter_familly_app/profileUtils/custom_clipper.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:flutter_familly_app/subViews/changeUserIcon.dart';
import 'package:flutter_familly_app/widgets/top_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_familly_app/services/auth.dart';

DocumentSnapshot ds;
final FirebaseHelper _firebaseHelper = FirebaseHelper();
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

bool isJoin = false;
bool isAdmin = false;
bool isFam;
String join_username;

class _UserProfile extends State<UserProfile> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  String _myThumbnail;
  String _myName;
  String _mystatus;
  String cuid;
  @override
  void initState() {
    _myName;
    _myThumbnail;
    super.initState();
    _firebaseHelper.isAdmin().then((value) {
      setState(() {
        isAdmin = value;
      });
      print(isAdmin);
    });
    _firebaseHelper.joinFamily().then((List list) {
      setState(() {
        join_username = list[0];
        isJoin = list[1];
        isFam = list[2];
      });
    });
  }

  void getCurrentUserData() async {
    bool currentStatus;
    cuid = await _firebaseHelper.getCurrentUser().then((user) => user.uid);
    ds = await _firestore.collection("users").doc(cuid).get();
    setState(() {
      _myName = ds.get("name");
      _myThumbnail = ds.get("avatar");
      currentStatus = ds.get("isAdmin");
      fid = ds.get('fid');
      if (currentStatus == false) {
        _mystatus = "Member";
      } else if (currentStatus == true) {
        _mystatus = "Owner";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(isAdmin);

    print(" ----------------------");
    print(join_username);
    print(isJoin);

    getCurrentUserData();
    String famillyId = fid;
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        height: 650,
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
                                          Image.asset(
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
                                  Icons.access_time,
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
                                    "Familly ID",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    '$fid',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12.0,
                                    ),
                                  ),
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
                                  Text(
                                    "Log Out",
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
                ],
              ),
            ),
            TopBar(),
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
      _myThumbnail = newThumbnail;
      _myName = newName;
      //push data to db
      _firestore.collection("users").doc(cuid).update({'avatar': _myThumbnail});
      _firestore.collection("users").doc(cuid).update({'name': _myName});
    });
    MyProfileData newMyData =
        MyProfileData(myName: newName, myThumbnail: newThumbnail);
    widget.updateMyData(newMyData);
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
                  ? new Text(join_username + "would like to join the family !")
                  : new Text("No Notifications ..."),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('ACCEPT'),
              onPressed: () async {
                String cuid = await _firebaseHelper
                    .getCurrentUser()
                    .then((user) => user.uid);
                DocumentSnapshot ds =
                    await firestore.collection("users").doc(cuid).get();
                DocumentSnapshot dsf = await firestore
                    .collection("families")
                    .doc(ds.get('fid'))
                    .get();
                List a = dsf.get('membersRequest');

                //update to members
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
}
