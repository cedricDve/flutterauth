import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/Animation/FadeAnimation.dart';
import 'package:flutter_familly_app/screens/register.dart';
import 'package:flutter_familly_app/services/auth.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const Login({
    Key key,
    @required this.auth,
    @required this.firestore,
  }) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  FirebaseHelper firebaseHelper = FirebaseHelper();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 400,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: 400,
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
                    height: 350,
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
                        "Login",
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
                                controller: emailController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
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
                        try {
                          firebaseHelper.resetPassword(emailController.text);
                          displayToastMessage(
                              "A reset email has been send to " +
                                  emailController.text,
                              context);
                        } catch (e) {
                          e.printStackTrace("No email detected");
                          displayToastMessage(
                              "Please put in a valid email adress", context);
                        }
                      },
                      child: FadeAnimation(
                          1.7,
                          Center(
                              child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Color.fromRGBO(196, 135, 198, 1)),
                          )))),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                      onTap: () async {
                        // signIn
                        final String returnValue = await Auth(auth: widget.auth)
                            .signIn(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim());
                        getToken();
                        if (returnValue == "Succes") {
                          emailController.clear();
                          passwordController.clear();
                        } else {
                          //show error
                          displayToastMessage(returnValue, context);
                          passwordController.clear();
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
                                "Login",
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
                              builder: (context) => RegisterPage()),
                        );
                      },
                      child: FadeAnimation(
                          2,
                          Center(
                              child: Text(
                            "Create Account",
                            style: TextStyle(
                                color: Color.fromRGBO(49, 39, 79, .6)),
                          )))),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

displayToastMessage(String msg, BuildContext context) {
  Fluttertoast.showToast(msg: msg);
}

Future<String> getToken() async {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final databaseReference = FirebaseFirestore.instance;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String cuid;
  cuid = Auth(auth: _auth).currentUser.uid;
  String userTokenThisDevice = prefs.get('FCMToken') as String;
  print(cuid);

  if (userTokenThisDevice == null) {
    _firebaseMessaging.getToken().then((val) async {
      print('Token: ' + val);
      prefs.setString('FCMToken', val);
    });
  }

  print(userTokenThisDevice);
  print("???????????????????");

  await FirebaseFirestore.instance
      .collection("users")
      .doc(cuid)
      .get()
      .then((val) async {
    //  'uniqueId': userToken
    if (val.get('uniqueId') == null) {
      print(userTokenThisDevice);
      print("???????????????????");
      databaseReference
          .collection("users")
          .doc(cuid)
          .update({'uniqueId': userTokenThisDevice});
    } else if (userTokenThisDevice != val.get('uniqueId')) {
      //STUUR EMAIL CODE HIER !
      String sender = 'firebasehelpme@gmail.com';
      String password = 'FBSupport1';

      //Create our email transport
      final smtpServer = gmail(sender, password);
      //var emailTransport = new SmtpTransport(options);
      final message = Message()
        ..from = 'firebasehelpme@gmail.com'
        ..recipients.add('${val.get('email')}')
        ..subject = 'Did you log in on: ${DateTime.now()} ?'
        ..html =
            "<h1>New device logged in on ${val.get('email')}</h1>\n<p>Someone just logged in on your account from another device. This email has been sent to your to check if it was you. If it is someone else, change your password as fast as possible on the app under the profile page</p>";
      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    }
  });

  return userTokenThisDevice;
}
