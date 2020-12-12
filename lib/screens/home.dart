import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/screens/Choose.dart';
import 'package:flutter_familly_app/screens/feedmain.dart';
import 'package:flutter_familly_app/screens/pages/calendarHome..dart';

import 'package:flutter_familly_app/screens/pages/test.dart';

import 'package:flutter_familly_app/services/auth.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:flutter_familly_app/widgets/navbarKey.dart';

import 'pages/chatlist.dart';

class Home extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const Home({Key key, this.auth, this.firestore}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

bool isJoin = false;
bool isFam;
String join_username;

class _HomeState extends State<Home> {
  PageController pageController;
  FirebaseHelper _firebaseHelper = FirebaseHelper();
  int _page = 0;

  String _userName = "Cédric";
  String _email = "Cédric";

  @override
  void initState() {
    // implement initState
    super.initState();
    pageController = PageController();
  }

// A function that look checks if the current user has a family. If the authenticated user has a family, he can continue, otherwise he will be redirected to a page where he can join or create a family
  void checkIsFamily() async {
    String cuid = Auth(auth: widget.auth).currentUser.uid;
    // Get data from Firestore of current user with cuid ->(CurrentUserID)
    DocumentSnapshot ds =
        await widget.firestore.collection("users").doc(cuid).get();
    if (ds.get('fid') == null)
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Choose()));
  }

  @override
  Widget build(BuildContext context) {
    checkIsFamily();
    /*_firebaseHelper.getFamMembers().then((List list) {
      setState(() {
        join_username = list[0];
        isJoin = list[1];
        isFam = list[2];
      });
    });*/
    final screen = [
      MyFeedPageMain(),
      ChatList(),
      ProfileP(
        userName: _userName,
        email: _email,
      ),
      TestPage(),
      CalendarHome(),
    ]; //  HomeP(auth: widget.auth, firestore: widget.firestore)

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        color: Colors.blue[100],
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.blue[200],
        index: _page,
        key: NavbarKey.getKey(),
        items: [
          Icon(
            Icons.home,
            size: 30,
          ),
          Icon(
            Icons.message,
            size: 30,
          ),
          Icon(
            Icons.group,
            size: 30,
          ),
          Icon(
            Icons.person,
            size: 30,
          ),
          Icon(
            Icons.calendar_today_rounded,
            size: 30,
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        animationDuration: const Duration(milliseconds: 300),
      ),
      body: screen[_page],
    );
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }
}

class ProfileP extends StatefulWidget {
  final String userName;
  final String email;
  ProfileP({this.userName, this.email});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  _ProfilePState createState() => _ProfilePState();
}

class _ProfilePState extends State<ProfileP> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseHelper _firebaseHelper = FirebaseHelper();

  @override
  Widget build(BuildContext context) {
    _firebaseHelper.joinFamily().then((List list) {
      setState(() {
        join_username = list[0];
        isJoin = list[1];
        isFam = list[2];
      });
    });
    print(" ----------------------");
    print(join_username);
    print(isJoin);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
            style: TextStyle(
                color: Colors.white,
                fontSize: 27.0,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black87,
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          children: <Widget>[
            Icon(Icons.account_circle, size: 150.0, color: Colors.grey[700]),
            SizedBox(height: 15.0),
            Text(widget.userName,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 7.0),
            ListTile(
              onTap: () {
                final CurvedNavigationBarState navState =
                    NavbarKey.getKey().currentState;
                navState.setPage(2);
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.group),
              title: Text('Groups'),
            ),
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: GestureDetector(
                onTap: () {
                  _showNotification();
                },
                child: (isJoin)
                    ? Icon(
                        Icons.notification_important,
                        color: Colors.red,
                      )
                    : Icon(Icons.notification_important),
              ),
              title: (isJoin)
                  ? Text('New Family Request')
                  : Text('No New Request'),
            ),
            ListTile(
              selected: true,
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              onTap: () async {
                await Auth(auth: widget._auth).signOut();
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 170.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.account_circle,
                    size: 200.0, color: Colors.grey[700]),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Full Name', style: TextStyle(fontSize: 17.0)),
                    Text(widget.userName, style: TextStyle(fontSize: 17.0)),
                  ],
                ),
                Divider(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Email', style: TextStyle(fontSize: 17.0)),
                    Text(widget.email, style: TextStyle(fontSize: 17.0)),
                  ],
                ),
              ],
            ),
          )),
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
                final CurvedNavigationBarState navState =
                    NavbarKey.getKey().currentState;
                navState.setPage(2);
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
