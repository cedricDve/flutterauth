import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_familly_app/screens/home.dart';
import 'package:flutter_familly_app/screens/login.dart';
import 'package:flutter_familly_app/screens/search.dart';
import 'package:flutter_familly_app/services/auth.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:flutter_familly_app/Animation/FadeAnimation.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future (outside  `build`)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: ThemeData.dark(),
      title: "Family App",
      //routing : / is the main route = main.dart
      initialRoute: "/",
      routes: {
        //all the other routes
        //multiple searchs
        '/search': (context) => SearchScreen(),
      },
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: const Text("Error"),
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
              child: const Text("Loading..."),
            ),
          );
        },
      ),
    );
  }
}

//User authenticated ? => Root decide were next page is
class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  User user;

  @override
  Widget build(BuildContext context) {
    // the functions I wrote returns future string so -> use streambuilder
    return StreamBuilder(
      //auth stream
      stream: Auth(auth: _auth).user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data?.uid == null) {
            //not logged in
            print("NOT LOGGED IN");
            return Login(
              auth: _auth,
              firestore: _firebaseFirestore,
            );
          } else {
            //logged in => email verify
            user = _auth.currentUser;
            bool checkMail = _firebaseHelper.isEmailVerified(user);
            if (!checkMail) {
              user.sendEmailVerification();
              return VerifyPage(auth: _auth, user: user);
            } else {
              print("WENT TO HOME");
              return Home(
                auth: _auth,
                firestore: _firebaseFirestore,
              );
            }
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

class VerifyPage extends StatefulWidget {
  final User user;
  final FirebaseAuth auth;

  const VerifyPage({Key key, this.user, this.auth}) : super(key: key);

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  @override
  Widget build(BuildContext context) {
    if (_firebaseHelper.isEmailVerified(widget.user)) Root();
    return Scaffold(
        body: Center(
            child: FadeAnimation(
      1.9,
      Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LinearProgressIndicator(),
              const SizedBox(height: 50.0),
              Image.network(
                'https://static4.depositphotos.com/1030387/456/v/600/depositphotos_4561981-stock-illustration-waiting-for-mailman.jpg',
                height: 300,
              ),
              SizedBox(height: 50.0),
              Text(
                  'An email has been sent to ${widget.user.email}. Please verify your email and log in again ! '),
              const SizedBox(height: 50.0),
              GestureDetector(
                  onTap: () async {
                    await Auth(auth: widget.auth).signOut();
                  },
                  child: FadeAnimation(
                      1.9,
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromRGBO(0, 171, 236, 1),
                        ),
                        child: Center(
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ))),
            ]),
      ),
    )));
  }
}
