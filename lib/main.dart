import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_familly_app/screens/home.dart';
import 'package:flutter_familly_app/screens/login.dart';
import 'package:flutter_familly_app/services/auth.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future (outside  `build`)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text("Error"),
              ),
            );
          }
          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Root();
          }
          // Otherwise, show something whilst waiting for initialization to complete
          return const Scaffold(
            body: Center(
              child: Text("Loading..."),
            ),
          );
        },
      ),
    );
  }
}

//User authenticated ?
// the Root decide were next page is
class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    // the functions i wrote returns future string so -> use streambuilder
    return StreamBuilder(
      //auth stream
      stream: Auth(auth: _auth).user,
      //builder
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data?.uid == null) {
            //not logged in
            return Login(
              auth: _auth,
              firestore: _firebaseFirestore,
            );
          } else {
            //logged in
            return Home(
              auth: _auth,
              firestore: _firebaseFirestore,
            );
          }
        } else {
          //connection still loading
          return const Scaffold(
            body: Center(
              child: Text("Loading..."),
            ),
          );
        }
      },
    );
  }
}
