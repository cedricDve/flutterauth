import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/services/auth.dart';

class HomeP extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const HomeP({Key key, this.auth, this.firestore}) : super(key: key);
  @override
  _HomePState createState() => _HomePState();
}

class _HomePState extends State<HomeP> {
  @override
  Widget build(BuildContext context) {
    print(widget.auth);
    return Container(
      child: RaisedButton(
        onPressed: () async {
          print("oke");
          await Auth(auth: widget.auth).signOut();
        },
        //sign Out

        child: Text("Sign out"),
      ),
    );
  }
}
