import 'package:flutter/material.dart';
import 'package:flutter_familly_app/services/firebaseMethods.dart';

class CustomMessageTile extends StatelessWidget {

  final String message;
  final String sender;
  final bool sentByMe;
  final String cid;
  final String mid;
  FirebaseMethods _firebaseHelper = FirebaseMethods();

  CustomMessageTile({this.message, this.sender, this.sentByMe, this.cid, this.mid});

  void _popupDialog(BuildContext context) {
    Widget deleteButton = FlatButton(
      child: Text("Delete"),
      onPressed: () async {
        if()
        await _firebaseHelper.deleteMessageForAll(cid, mid);
        Navigator.of(context).pop();
        },
    );

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();

      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Delete the message ?"),
      actions: [
        deleteButton,
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
          onLongPress: () {
            _popupDialog(context);
          },
          child: Container(
            margin: sentByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
            padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: sentByMe ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23)
              )
                  :
              BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)
              ),
              color: sentByMe ? Colors.blue[200] : Colors.grey[700],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Text(sender.toUpperCase(), textAlign: TextAlign.start, style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -0.5)),
                SizedBox(height: 7.0),
                Text(message, textAlign: TextAlign.start, style: TextStyle(fontSize: 15.0, color: Colors.black)),
              ],
            ),
          ),
        ),
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: sentByMe ? 0 : 24,
          right: sentByMe ? 24 : 0),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}