import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/commons/const.dart';
import 'package:flutter_familly_app/models/user.dart';
import 'package:flutter_familly_app/services/auth.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_familly_app/commons/utils.dart';
import 'package:flutter_familly_app/controllers/FBCloudMessaging.dart';
import 'threadMain.dart';

class MyFeedPageMain extends StatelessWidget {
  //final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: MyFeedPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyFeedPage extends StatefulWidget {
  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> with TickerProviderStateMixin {
  MyProfileData myData;

  bool _isLoading = false;
  FirebaseHelper _firebaseHelper = FirebaseHelper();
  FirebaseFirestore _fs = FirebaseFirestore.instance;

  @override
  void initState() {
    FBCloudMessaging.instance.takeFCMTokenWhenAppLaunch();
    FBCloudMessaging.instance.initLocalNotification();
    _takeMyData();
    super.initState();
  }

// DATA
  Future<void> _takeMyData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myThumbnail;
    String myName;

    String cuid =
        await _firebaseHelper.getCurrentUser().then((user) => user.uid);
    DocumentSnapshot ds = await _fs.collection('users').doc(cuid).get();
    print("¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨");
    print(ds.get('name'));
    myThumbnail = ds.get('avatar');

    if (prefs.get('myThumbnail') == null) {
      String tempThumbnail = iconImageList[Random().nextInt(50)];
      prefs.setString('myThumbnail', tempThumbnail);
      myThumbnail = tempThumbnail;
    }
//change username !!!
    prefs.setString('myName', ds.get('name'));

    setState(() {
      myData = MyProfileData(
        myThumbnail: myThumbnail,
        myName: ds.get('name'),
        myLikeList: prefs.getStringList('likeList'),
        myLikeCommnetList: prefs.getStringList('likeCommnetList'),
        myFCMToken: prefs.getString('FCMToken'),
      );
    });

    setState(() {
      _isLoading = false;
    });
  }

  void updateMyData(MyProfileData newMyData) {
    setState(() {
      myData = newMyData;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("SUCCESS");
    print(Auth(auth: FirebaseAuth.instance).currentUser);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('FamMe'),
        centerTitle: true,
        backgroundColor: Colors.blue[200],
      ),
      body: ThreadMain(
        myData: myData,
        updateMyData: updateMyData,
      ),
    );
  }
}
