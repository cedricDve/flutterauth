import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/screens/Choose.dart';
import 'package:flutter_familly_app/screens/feedmain.dart';
import 'package:flutter_familly_app/screens/pages/Event/famEventList.dart';
import 'package:flutter_familly_app/screens/pages/calendarHome..dart';
import 'package:flutter_familly_app/screens/userProfile.dart';
import 'package:flutter_familly_app/services/auth.dart';
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
  int _page = 0;
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

    if (await ds.get('fid') == null || await ds.get('isFamily') == false) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Choose()));
    }
  }

  @override
  Widget build(BuildContext context) {
    checkIsFamily();
    final screen = [
      MyFeedPageMain(),
      ChatList(),
      ProfileP(),
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
  @override
  _ProfilePState createState() => _ProfilePState();
}

class _ProfilePState extends State<ProfileP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserProfile(),
    );
  }
}
