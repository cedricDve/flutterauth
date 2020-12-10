import 'package:flutter/material.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:flutter_familly_app/widgets/customAppBar.dart';
import 'package:flutter_familly_app/widgets/customChat.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

//global final var
final FirebaseHelper fHelper = FirebaseHelper();

class _ChatListState extends State<ChatList> {
  String currentUid;

  @override
  void initState() {
    super.initState();
    //get the current user uid
    fHelper.getCurrentUser().then((user) {
      setState(() {
        currentUid = user.uid;
      });
    });
  }

  CustomAppBar customAppBar(BuildContext context) {
    String username = "Name";
    return CustomAppBar(
        title: LogoUser(username[0]),
        leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.notification_important),
            color: Colors.black),
        centerTitle: true,
        actions: <Widget>[
          //Search
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                //When user press SearchButton -> change view -> navigator with route
                Navigator.pushNamed(context, "/search");
              })
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      floatingActionButton: NewChatBtn(),
      body: ChatListContainer(currentUid),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  final String currentUserid;
  ChatListContainer(this.currentUserid);
  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 2,
        itemBuilder: (context, index) {
          return CustomChat(
            mini: false,
            onTap: () {},
            onLongPress: () {},
            title: Text("Test", style: TextStyle(color: Colors.black)),
            subtitle: Text("Subtitle"),
            leading: Container(
              constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                        "https://w7.pngwing.com/pngs/359/1024/png-transparent-firebase-cloud-messaging-computer-icons-google-cloud-messaging-android-angle-triangle-computer-programming-thumbnail.png"),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.green),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Button that let the user make a new message: always present, right bottom
class NewChatBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(50)),
      child: Icon(Icons.edit, color: Colors.black, size: 25),
      padding: EdgeInsets.all(25),
    );
  }
}

class LogoUser extends StatelessWidget {
  final String text;
  //constructor -> passing a text: username
  LogoUser(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.blue),
        child: //using a stack -> 2 items
            Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                )),
          ],
        ));
  }
}
