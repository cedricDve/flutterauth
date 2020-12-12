import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/Animation/FadeAnimation.dart';
import 'package:flutter_familly_app/commons/const.dart';
import 'package:flutter_familly_app/models/user.dart';
import 'package:flutter_familly_app/screens/Choose.dart';
import 'package:flutter_familly_app/screens/login.dart';
import 'package:flutter_familly_app/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  UserModel userModel = UserModel();
  DateTime _dateTime;
  TextEditingController emailControler = new TextEditingController();
  TextEditingController passwordControler = new TextEditingController();
  TextEditingController _passwordControler = new TextEditingController();
  TextEditingController nameControler = new TextEditingController();
  TextEditingController birthdayControler = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
          Container(
            height: 260,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -40,
                  height: 300,
                  width: width,
                  child: FadeAnimation(
                      1,
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/layer2.png'),
                                fit: BoxFit.fill)),
                      )),
                ),
                Positioned(
                  height: 250,
                  width: width + 20,
                  child: FadeAnimation(
                      1.3,
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/layer.png'),
                                fit: BoxFit.fill)),
                      )),
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                      1.5,
                      Text(
                        "Register",
                        style: TextStyle(
                            color: Color.fromRGBO(49, 39, 79, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                      1.7,
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(196, 135, 198, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              )
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]))),
                              child: TextField(
                                controller: nameControler,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Username",
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]))),
                              child: TextField(
                                controller: emailControler,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]))),
                              child: GestureDetector(
                                  onTap: () {
                                    // signIn
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime(2000),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2024))
                                        .then((data) {
                                      setState(() {
                                        _dateTime = data;
                                        displayToastMessage(
                                            _dateTime
                                                .toIso8601String()
                                                .split('T')
                                                .first,
                                            context);
                                      });
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 60),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Color.fromRGBO(0, 171, 236, 1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Pick your Birthday",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]))),
                              child: TextField(
                                controller: passwordControler,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey)),
                                autofocus: false,
                                obscureText: true,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextField(
                                controller: _passwordControler,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Repeat Password",
                                    hintStyle: TextStyle(color: Colors.grey)),
                                autofocus: false,
                                obscureText: true,
                              ),
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () async {
                        String myThumbnail;

                        String tempThumbnail =
                            iconImageList[Random().nextInt(50)];

                        myThumbnail = tempThumbnail;

                        if (passwordControler.text == _passwordControler.text) {
                          // signIn
                          final String returnValue =
                              await Auth(auth: widget.auth).createAccount(
                                  email: emailControler.text.trim(),
                                  password: passwordControler.text.trim());
                          //Store user info to Firestore
                          if (nameControler.text.length < 3 &&
                              nameControler.text.length < 20)
                            displayToastMessage(
                                "Your name must be at least 3 characters ",
                                context);
                          if (_dateTime == null)
                            displayToastMessage(
                                "Please select your birthday ", context);
                          print(widget.auth.currentUser.uid);
                          // Put data into userModel !
                          userModel = UserModel(
                            uid: widget.auth.currentUser.uid,
                            email: emailControler.text.trim(),
                            name: nameControler.text.trim(),
                            birthday:
                                _dateTime.toIso8601String().split('T').first,
                            avatar: myThumbnail,
                            isFamily: false,
                            isAdmin: false,
                          );
                          print(userModel.uid + userModel.email);
                          widget.firestore
                              .collection("users")
                              .doc(widget.auth.currentUser.uid)
                              .set(userModel.toMap(userModel));

                          if (returnValue == "Success") {
                            emailControler.clear();
                            passwordControler.clear();
                            /* Navigator.pushNamed(context,
                                "/chosefam"); */
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Choose()));
                          } else {
                            //show error
                            displayToastMessage(returnValue, context);
                          }
                        } else {
                          displayToastMessage(
                              "Please make sure your password is the same !",
                              context);
                          _passwordControler.clear();
                          passwordControler.clear();
                        }
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
                              child: Text(
                                "Register",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ))),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login(
                                  auth: widget.auth,
                                  firestore: widget.firestore,
                                )),
                      );
                    },
                    child: FadeAnimation(
                        2,
                        Center(
                          child: Text(
                            "Log In",
                            style: TextStyle(
                                color: Color.fromRGBO(49, 39, 79, .6)),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              )),
        ])));
  }

  displayToastMessage(String msg, BuildContext context) {
    Fluttertoast.showToast(msg: msg);
  }
}
