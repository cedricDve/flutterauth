import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/main.dart';
import 'package:provider/provider.dart';
import 'firebase_services/auth.dart';

class OnceLoggedIn extends StatefulWidget {
  @override
  _OnceLoggedInState createState() => _OnceLoggedInState();
}

class _OnceLoggedInState extends State<OnceLoggedIn> {
  PageController pageController;
  double _labelfontsize = 12;
  int _page = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        children: <Widget>[
          Center(
            child: Column(
              children: [
                Text("Home"),
                RaisedButton(
                  onPressed: () {
                    readData();
                  },
                  child: Text("Read Data"),
                ),
                RaisedButton(
                  onPressed: () {
                    context.read<Auth>().signOut();
                  },
                  child: Text("Sign out"),
                ),
              ],
            ),
          ),
          Center(child: Text("Second Page")),
          Center(child: Text("Third Page")),
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

  void readData() {
    usersRef.once().then((DataSnapshot datasnapshot) {
      print(datasnapshot.value);
    });
  }
}

void main() => runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: OnceLoggedIn()));

/*
    //update
    usersRef.child("userid").update({
      //value
    });

       //delete
    usersRef.child("userid").remove();
    */
