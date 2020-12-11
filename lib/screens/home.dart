import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/screens/Choose.dart';
import 'package:flutter_familly_app/screens/pages/homePage.dart';
import 'package:flutter_familly_app/screens/pages/test.dart';
import 'package:flutter_familly_app/screens/register.dart';
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

  void checkFamily() async {
    String cuid =
        await _firebaseHelper.getCurrentUser().then((user) => user.uid);
    DocumentSnapshot ds =
        await widget.firestore.collection("users").doc(cuid).get();
    if (ds.get('fid') == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Choose()));
    }
  }

  @override
  Widget build(BuildContext context) {
    checkFamily();
    final screen = [
      ProfileP(
        userName: _userName,
        email: _email,
      ),
      ChatList(),
      RegisterPage(),
      TestPage(),
      HomeP(auth: widget.auth, firestore: widget.firestore)
    ];
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
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
            Icons.settings,
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
  @override
  Widget build(BuildContext context) {
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
}
