import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/screens/chatscreens/createConversations.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:flutter_familly_app/models/user.dart';
import 'package:flutter_familly_app/screens/chatscreens/chat.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversations"),
        automaticallyImplyLeading: false ,
      ),
      floatingActionButton: NewChatBtn(),
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  FirebaseHelper firebaseHelper = FirebaseHelper();
  Stream<QuerySnapshot> _conversations;
  List<UserModel> userList = List<UserModel>();
  
  @override
  void initState() {
    super.initState();
    //TODO: make a cloud function
    firebaseHelper.fetchAllConversations().then((list) => {
      setState(() {
        _conversations = list;
      }),
    });
    firebaseHelper.fetchUsersWithFid().then((usersList) {
      setState(() {
        userList = usersList;
      });
    });
  }

  Widget noConversationWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
              child: Icon(Icons.edit, color: Colors.grey[700], size: 75.0)
          ),
          SizedBox(height: 15.0),
          Text("You've not start a conversation, tap on the 'edit' icon to create a conversation."),
        ],
      ),
    );
  }

  String takeUserWithCuid(snapshot, index){
    String cuid =  snapshot.data.documents[index].data()["memberSender"][0];
    //if(userList.length > 0){
      for(var i = 0; i < userList.length; i++){
        if(cuid == userList[i].uid){
          print(userList[i].name);
          //names.add(userList[i].name);
          return userList[i].name;
        }
      }
    //}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: _conversations,
          builder: (context, snapshot){
            if(snapshot.hasData){
              if(snapshot.data != null){
                if(snapshot.data.documents.length != 0) {
                  return ListView.builder(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      String name = takeUserWithCuid(snapshot, index);
                      if(name != null ){
                      return ListTile(
                        leading: Icon(
                            Icons.account_circle //searchResults[index].avatar
                        ),
                        title: Text(name),
                        onTap: () {
                          String cid = snapshot.data.documents[index].data()["cid"];
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ChatScreen(cid: cid)));
                        },
                        /*
                        trailing: Icon(
                            Icons.delete
                        ),
                         */
                      );
                      } else {
                        return Center(
                            child: CircularProgressIndicator()
                        );
                      }
                    },
                  );
                } else {
                  return noConversationWidget();
                  }
              } else {
                // view to add a new view: make a conversation
                return noConversationWidget();
              }
            } else {
              return Center(
                  child: CircularProgressIndicator()
              );
            }}
      ),
    );
  }
}

// Button that let the user make a new message: always present, right bottom
class NewChatBtn extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: FloatingActionButton(
        child: Icon(
            Icons.edit, color: Colors.black, size: 25
        ),
        onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => createConversations()));
        },
      ),
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