import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/commons/const.dart';
import 'package:flutter_familly_app/commons/utils.dart';
import 'package:flutter_familly_app/screens/writePost.dart';
import 'package:flutter_familly_app/screens/home.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:flutter_familly_app/subViews/threadItem.dart';

import 'contentDetail.dart';

class ThreadMain extends StatefulWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MyProfileData myData;
  final ValueChanged<MyProfileData> updateMyData;
  ThreadMain({this.myData, this.updateMyData});
  @override
  State<StatefulWidget> createState() => _ThreadMain();
}

class _ThreadMain extends State<ThreadMain> {
  bool _isLoading = true;
  FirebaseHelper _firebaseHelper = FirebaseHelper();

  String fID;
  bool isFamily;

  void _writePost() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WritePost(
                  myData: widget.myData,
                )));
  }

  void getFidCurrentUser() async {
    String cuid =
        await _firebaseHelper.getCurrentUser().then((user) => user.uid);
    DocumentSnapshot ds =
        await widget._firestore.collection("users").doc(cuid).get();

    setState(() {
      fID = ds.get('fid');
    });
  }

  void getCurrentUserIsFamily() async {
    String cuid =
        await _firebaseHelper.getCurrentUser().then((user) => user.uid);
    DocumentSnapshot ds =
        await widget._firestore.collection("users").doc(cuid).get();
    print(ds.get('isFamily'));

    setState(() {
      isFamily = ds.get('isFamily');
    });
  }

  @override
  void initState() {
    super.initState();
    getFidCurrentUser();
    getCurrentUserIsFamily();
  }

  @override
  Widget build(BuildContext context) {
    print(isFamily);
    print("!!");
    // get fid of current user => use fID to have fid of current user

    return RefreshIndicator(
      onRefresh: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      },
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('families')
                .doc(fID)
                .collection('thread')
                .orderBy('postTimeStamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              //if no data => tru e: false
              if (!snapshot.hasData) return LinearProgressIndicator();

              return Stack(
                children: <Widget>[
                  (snapshot.data.docs.length > 0 && isFamily && _isLoading)
                      ? ListView(
                          shrinkWrap: true,
                          children:
                              snapshot.data.docs.map((DocumentSnapshot data) {
                            if (data != null) {
                              _isLoading = false;
                              return ThreadItem(
                                data: data,
                                myData: widget.myData,
                                updateMyDataToMain: widget.updateMyData,
                                threadItemAction: _moveToContentDetail,
                                isFromThread: true,
                                commentCount: data['postCommentCount'],
                                parentContext: context,
                              );
                            }
                          }).toList(),
                        )
                      : Container(
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.error,
                                color: Colors.grey[700],
                                size: 64,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text(
                                  'There is no post',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[700]),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )),
                        ),
                  if (_isLoading)
                    LinearProgressIndicator()
                  else
                    Utils.loadingCircle(_isLoading)
                ],
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: _writePost,
          tooltip: 'Increment',
          child: Icon(Icons.create),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  void _moveToContentDetail(DocumentSnapshot data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContentDetail(
                  postData: data,
                  myData: widget.myData,
                  updateMyData: widget.updateMyData,
                )));
  }
}
