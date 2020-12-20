import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/Animation/FadeAnimation.dart';
import 'package:flutter_familly_app/models/families.dart';
import 'package:flutter_familly_app/main.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Create());
}

class Create extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: CreateStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class CreateStatefulWidget extends StatefulWidget {
  CreateStatefulWidget({Key key}) : super(key: key);
  @override
  _CreateStatefulWidgetState createState() => _CreateStatefulWidgetState();
}

class _CreateStatefulWidgetState extends State<CreateStatefulWidget> {
  TextEditingController fnameController = new TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseHelper firebaseHelper = FirebaseHelper();
  //counter(veilig invoer)
  int counter = 0;
  //Random
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {
    String code = getRandomString(5);
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
                        "Create",
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
                                controller: fnameController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter a Family name",
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                      onTap: () async {
                        bool success = true;
                        String cuid = await firebaseHelper
                            .getCurrentUser()
                            .then((user) => user.uid);
                        //QuerySnapshot g=  await FirebaseFirestore.instance.collection("users").where(cuid).get();
                        //print(g.docs[1].get('uid'));

                        await _firestore
                            .collection("families")
                            .doc(code)
                            .get()
                            .then((value) {
                          if (value.exists) {
                            success = false;
                          }
                        });
                        if (success) {
                          FamilyModel famModel = FamilyModel(
                            fid: code,
                            fname: fnameController.text.trim(),
                            avatar: null,
                            members: [cuid],
                            membersRequest: [],
                          );

                          //Put the family code => fid in the current Auth user
                          await _firestore
                              .collection("families")
                              .doc(code)
                              .set(famModel.toMap(famModel))
                              .then((value) =>
                                  Fluttertoast.showToast(msg: "Success"))
                              .catchError(
                                  (e) => Fluttertoast.showToast(msg: e));

                          DocumentSnapshot qs = await _firestore
                              .collection("users")
                              .doc(cuid)
                              .get();
                          print(qs.get('fid'));
                          if (qs.get('fid') == null ||
                              qs.get('isFamily') == false) {
                            await _firestore
                                .collection("users")
                                .doc(cuid)
                                .update({
                                  'fid': code,
                                  'isFamily': true,
                                  'isAdmin': true
                                })
                                .then((value) =>
                                    Fluttertoast.showToast(msg: "Fid Set"))
                                .catchError(
                                    (e) => Fluttertoast.showToast(msg: e));
                          }
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Root()));
                        } else {
                          Fluttertoast.showToast(msg: "error");
                          counter++;
                          if (counter == 100) {
                            code = getRandomString(6);
                            Fluttertoast.showToast(
                                msg: "Push one more time to get a new code");
                            counter = 0;
                          }
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
                                "Create your family Code",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ))),
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                      1.7,
                      Center(
                        child: Container(
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
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: Text("yfzgiz"),
                              ),
                            ],
                          ),
                        ),
                      )),
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
