import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/once_loggedin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Animation/FadeAnimation.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart'; context read -> need provider
import 'firebase_services/auth.dart';
import 'main.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: RegisterPage()));
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  DateTime _dateTime;
  TextEditingController emailControler = new TextEditingController();
  TextEditingController passwordControler = new TextEditingController();
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
                            Text(_dateTime == null
                                ? "No date has been picked yet"
                                : _dateTime.toIso8601String().split('T').first),
                            RaisedButton(
                                child: Text("Pick your birthay"),
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime(2000),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2024))
                                      .then((data) {
                                    setState(() {
                                      _dateTime = data;
                                    });
                                  });
                                }),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]))),
                              child: TextField(
                                controller: birthdayControler,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Birthday",
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
                      onTap: () {
                        print("Active");
                        if (nameControler.text.length < 4)
                          displayToastMessage(
                              "Name must be at least 3 characters.", context);
                        else if (!emailControler.text.contains('@'))
                          displayToastMessage(
                              "Email is invalid, must contain '@'.", context);
                        else if (_dateTime == null)
                          displayToastMessage(
                              "Please pick your birthday", context);
                        else if (passwordControler.text.length < 7)
                          displayToastMessage(
                              "Password must be at least 6 characters.",
                              context);
                        else
                          createAccount(context);

                        //code
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
                        MaterialPageRoute(builder: (context) => HomePage()),
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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void createAccount(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
      email: emailControler.text.trim(),
      password: passwordControler.text.trim(),
    )
            .catchError((errMsg) {
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;
    if (firebaseUser != null) {
      //save in RTDB

      Map userDataMap = {
        "name": nameControler.text.trim(),
        "email": emailControler.text.trim(),
        "birthday": _dateTime.toIso8601String().split('T').first,
      };
      //usersRef init in main
      usersRef.child(firebaseUser.uid).set(userDataMap);

      displayToastMessage("Useraccount has been created", context);

      //Nav to home, once user is logged in
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      //error RTDB
      displayToastMessage("Useraccount has Not been created", context);
    }
  }

  displayToastMessage(String msg, BuildContext context) {
    Fluttertoast.showToast(msg: msg);
  }
}
