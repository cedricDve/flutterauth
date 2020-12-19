import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/screens/Choose.dart';
import 'package:flutter_familly_app/screens/feedmain.dart';
//import 'package:flutter_familly_app/screens/pages/Event/eventPage.dart';
//import 'package:flutter_familly_app/screens/pages/Event/homeEvent.dart';
import 'package:flutter_familly_app/screens/pages/Event/famEventList.dart';
import 'package:flutter_familly_app/screens/pages/calendarHome..dart';
import 'package:flutter_familly_app/screens/userProfile.dart';
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
    final screen = [
      MyFeedPageMain(),
      ChatList(),
      ProfileP(
        userName: _userName,
        email: _email,
      ),
      HomeFamEvents(),
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
      body: UserProfile(),
    );
  }
}
