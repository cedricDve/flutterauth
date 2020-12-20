// ignore: prefer_double_quotes
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
import 'introductionScreen.dart';
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

bool isJoin = false;
bool isAdmin = false;
bool isFam;
String join_username;

class _UserProfile extends State<UserProfile> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  String _myThumbnail;
  String _myName;
  String famName;
  String _mystatus;
  String cuid;
  List<FamMemberModel> listFamModel = List<FamMemberModel>();
  @override
  void initState() {
    super.initState();
    _firebaseHelper.isAdmin().then((value) {
      setState(() {
        isAdmin = value;
      });
      print(isAdmin);
    });
    _firebaseHelper.joinFamily().then((List list) {
      setState(() {
        join_username = list[0] as String;
        isJoin = list[1] as bool;
        isFam = list[2] is bool;
      });
    });
    _firebaseHelper.getFamilyAvatars().then((List<FamMemberModel> value) {
      setState(() {
        listFamModel = value;
      });
    });
  }

  void getCurrentUserData() async {
    bool currentStatus;
    cuid = await _firebaseHelper.getCurrentUser().then((user) => user.uid);
    ds = await _firestore.collection("users").doc(cuid).get();
    setState(() {
      _myName = ds.get('name') as String;
      _myThumbnail = ds.get('avatar') as String;
      currentStatus = ds.get('isAdmin') as bool;
      fid = ds.get('fid') as String;
      if (currentStatus == false) {
        _mystatus = 'Member';
      } else if (currentStatus == true) {
        _mystatus = 'Owner';
      }
    });
    DocumentSnapshot fds =
        await firestore.collection('families').doc(fid).get();
    setState(() {
      famName = fds.get('fname') as String;
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

    return SingleChildScrollView(
      child: Container(
        height: isAdmin ? 1000 : 900,
        child: Stack(
          children: <Widget>[
            Container(),
            ClipPath(
                clipper: MyCustomClipper(),
                child: FadeAnimation(
                  1.5,
                  Container(
                    height: 300.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/layer.png"),
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
                                          ChangeUserIcon('$_myThumbnail')??ChangeUserIcon('$_myThumbnail'),
                                      barrierDismissible: true,
                                    ).then((newMyThumbnail) {
                                      _updateMyData(_myName, newMyThumbnail as String);
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
                  new SizedBox(
                    height: 120.0,
                    width: double.infinity,
                    child: new ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listFamModel.length,
                        itemBuilder: (BuildContext context, int index) =>
                            new Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  new Container(
                                      width: 80,
                                      height: 80,
                                      child: new Image.asset(
                                          'assets/images/${listFamModel[index].avatar}')),
                                  new Container(
                                    child: new Text(listFamModel[index].id) ??
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
                    // ignore: prefer_double_quotes
                    .doc(ds.get('fid') as String)
                    .get();
                List a = dsf.get('membersRequest') as List<dynamic>;

                //update to members
                await FirebaseFirestore.instance
                    .collection("families")
                    .doc(ds.get('fid') as String)
                    .update({
                  'members': FieldValue.arrayUnion([a[0]])
                });
                // set joined user to isFamily true
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(a[0] as String)
                    .update({'isFamily': true});

                //delete from membersRequest
                await FirebaseFirestore.instance
                    .collection("families")
                    .doc(ds.get('fid') as String)
                    .update({
                  'membersRequest': FieldValue.arrayRemove([a[0]])
                });
                setState(() {
                  isJoin = false;
                });
                Navigator.pop(context);
              }),
          //admin declines a user
          new FlatButton(
              child: const Text('DECLINE'),
              onPressed: () async {
                //update to members
                String cuid = await _firebaseHelper
                    .getCurrentUser()
                    .then((user) => user.uid);
                DocumentSnapshot ds =
                    await firestore.collection("users").doc(cuid).get();
                DocumentSnapshot dsf = await firestore
                    .collection("families")
                    .doc(ds.get('fid') as String)
                    .get();
                setState(() {});
                List a = dsf.get('membersRequest') as List<dynamic>;
                // set joined user to isFamily false
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(a[0] as String)
                    .update({'isFamily': false});

                //delete from membersRequest
                await FirebaseFirestore.instance
                    .collection("families")
                    .doc(ds.get('fid') as String)
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
