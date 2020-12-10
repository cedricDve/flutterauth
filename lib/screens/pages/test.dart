import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/screens/pages/eventTest.dart';

void main() => runApp(TestPage());

class TestPage extends StatelessWidget {
  // Tween<double> _scaleTween = Tween<double>(begin: 1, end: 2);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Some text",
      home: EventTest(),
      /*Scaffold(
          body: Center(
        child: TweenAnimationBuilder(
          tween: _scaleTween,
          duration: Duration(milliseconds: 600),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Container(
            width: 200,
            height: 200,
            color: Colors.lightBlue[300],
            child: Center(
              child: Text(
                "fuhzk",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ),
        ),
      )),*/
    );
  }
}
