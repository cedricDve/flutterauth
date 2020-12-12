import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/Animation/FadeAnimation.dart';
import 'package:flutter_familly_app/screens/home.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(Join());
}

class Join extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: JoinStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class JoinStatefulWidget extends StatefulWidget {
  JoinStatefulWidget({Key key}) : super(key: key);
  @override
  _JoinStatefulWidgetState createState() => _JoinStatefulWidgetState();
}

class _JoinStatefulWidgetState extends State<JoinStatefulWidget> {
  TextEditingController codeFamillyController = new TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
                        "Join",
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
                                controller: codeFamillyController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Familly Code",
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                      onTap: () async {
                        String cuid = await firebaseHelper
                            .getCurrentUser()
                            .then((user) => user.uid);
                        DocumentSnapshot qsu = await _firestore
                            .collection("users")
                            .doc(cuid)
                            .get();
                        await FirebaseFirestore.instance
                            .collection("families")
                            .doc(codeFamillyController.text.trim())
                            .get()
                            .then((value) {
                          if (value.exists) {
                            print(qsu.get('fid'));
                            if (qsu.get('fid') == null) {
                              _firestore
                                  .collection("users")
                                  .doc(cuid)
                                  .update({
                                    'fid': codeFamillyController.text.trim(),
                                    'isFamily':
                                        false, // he join => neeed to be accepted by admin ! if a user a a family code and isFamily is false => wait admin to validate
                                    'isAdmin': false
                                  })
                                  .then((value) =>
                                      Fluttertoast.showToast(msg: "Fid Set"))
                                  .catchError(
                                      (e) => Fluttertoast.showToast(msg: e));
                              //members request list add
                              _firestore
                                  .collection("families")
                                  .doc(codeFamillyController.text.trim())
                                  .update({
                                'membersRequest': FieldValue.arrayUnion([cuid])
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()));
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "Family Code don't exist");
                          }
                        });
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
                                "Join you familie",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ))),
                  SizedBox(
                    height: 30,
                  ),
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
