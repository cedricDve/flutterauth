import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/screens/Choose.dart';
import 'package:flutter_familly_app/services/auth.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';

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
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    pageController = PageController();
  }
void checkFamily() async{
  String cuid = await _firebaseHelper.getCurrentUser().then((user) => user.uid);
  DocumentSnapshot ds =  await widget.firestore.collection("users").doc(cuid).get();
  if(ds.get('fid') == null)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Choose()));

  }
}
  @override
  Widget build(BuildContext context) {
    checkFamily();
    return Scaffold(

      backgroundColor: Colors.black,
      body: PageView(
        children: <Widget>[
          Center(
            child: Column(
              children: [
                Text("Home"),
                RaisedButton(
                  onPressed: () async {
                    //sign Out
                    await Auth(auth: widget.auth).signOut();

                  },
                  child: Text("Sign out"),

                ),
              ],
            ),
          ),
          AppBar(
            title: const Text("Add a Task"),
            actions: [
              IconButton(icon: const Icon(Icons.exit_to_app), onPressed: () {})
            ],
          ),
          Container(child: ChatList()),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CupertinoTabBar(
            backgroundColor: Colors.white,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.chat,
                    color: (_page == 0) ? Colors.lightBlue : Colors.green),
                label: "Chats",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contact_phone,
                    color: (_page == 1) ? Colors.lightBlue : Colors.green),
                label: "Feed",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.call,
                    color: (_page == 2) ? Colors.lightBlue : Colors.green),
                label: "Call",
              )
            ],
            onTap: navigationTapped,
            currentIndex: _page,
          ),
        ),
      ),
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
