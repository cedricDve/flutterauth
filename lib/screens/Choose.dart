import 'package:flutter/material.dart';
import 'package:flutter_familly_app/Animation/FadeAnimation.dart';
import 'package:flutter_familly_app/screens/Join.dart';
import 'package:flutter_familly_app/screens/create.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(Choose());
}

class Choose extends StatelessWidget {
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
  TextEditingController codeFamillyController = new TextEditingController();
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
              padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                      1.5,
                      Text(
                        "Create or Join",
                        style: TextStyle(
                            color: Color.fromRGBO(49, 39, 79, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute( builder: (context)=> Create()));
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
                                "Create you familly",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ))),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute( builder: (context)=> Join()));
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
                                "Join your familly",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ))),

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