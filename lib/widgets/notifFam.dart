import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Requests'),
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black)),
              child: ListTile(
                title: Text("........ wants to join the group"),
                subtitle: Text("Date of request"),
                trailing:
                    Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        print("WELCOM");
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.do_not_disturb,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        print("SIYEB DE USER");
                      }),
                ]),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
