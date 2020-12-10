import 'package:flutter/material.dart';
import 'package:flutter_familly_app/models/user.dart';

class ChatScreen extends StatefulWidget {
  final UserModel receiver;
  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
