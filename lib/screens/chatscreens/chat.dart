import 'package:flutter/material.dart';
import 'package:flutter_familly_app/models/user.dart';
import 'package:flutter_familly_app/screens/chatscreens/customMessagesTile.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';

class ChatScreen extends StatefulWidget {
  final UserModel receiver;
  String cid;
  String name;
  String image;
  ChatScreen({this.receiver, this.cid, this.name, this.image});

  @override
  _ChatScreenState createState() => _ChatScreenState(cid, name);
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseHelper firebaseHelper = FirebaseHelper();
  Stream _messages;
  String cuid;
  TextEditingController messageEditingController = new TextEditingController();
  _ChatScreenState(cid, name);

  @override
  void initState() {
    super.initState();
    //TODO:make a cloud function
    firebaseHelper.fetchAllMessages(widget.cid).then((list) => {
      setState(() {
        _messages = list;
      }),
    });
    firebaseHelper.getCurrentUser().then((user) {
      setState(() {
        cuid = user.uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.blue[200],
      ),

      body: Container(
        child: Stack(
          children: <Widget>[
            chatList(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Colors.grey[700],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(
                            color: Colors.white
                        ),
                        decoration: InputDecoration(
                            hintText: "Send a message ...",
                            hintStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 16,
                            ),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    GestureDetector(
                      onTap:()async{
                        _sendMessage();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Center(
                            child: Icon(Icons.send, color: Colors.white)
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      firebaseHelper.createMessage(messageEditingController.text.trim(), widget.cid);
      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  Widget noMessageWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
              child: new Image.asset('assets/images/${widget.image}'),
          ),
          SizedBox(height: 15.0),
          Text("You've not start to convert with ${widget.name}."),
        ],
      ),
    );
  }

  Widget chatList(){
    //Stream _messages;
    return StreamBuilder(
        stream: _messages,
        builder: (context, snapshot){
          //TODO: if the list of messages have data = not sure i need do do this
          if(snapshot.hasData){
            if(snapshot.data != null) {
              if(snapshot.data.documents.length != 0) {
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return CustomMessageTile(
                        message: snapshot.data.documents[index].data()["message"],
                        sentByMe: cuid ==
                            snapshot.data.documents[index].data()["sender"],
                        cid: widget.cid,
                        mid: snapshot.data.documents[index].data()["mid"]
                    );
                  },
                );
              } else {
                return noMessageWidget();
              }
            } else {
              return noMessageWidget();
            }
          } else {
            return LinearProgressIndicator();
          }
        }
    );
  }
}