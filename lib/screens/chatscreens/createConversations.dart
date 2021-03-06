import 'package:flutter/material.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:flutter_familly_app/models/user.dart';

class CreateConversations extends StatefulWidget {
  @override
  _CreateConversationsState createState() => _CreateConversationsState();
}

class _CreateConversationsState extends State<CreateConversations> {
  FirebaseHelper firebaseHelper = FirebaseHelper();
  List<UserModel> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firebaseHelper.fetchUsersWithFid().then((usersList) {
      setState(() {
        userList = usersList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('new conversation'),
        backgroundColor: Colors.blue[200],
      ),
      body: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.blue[200],
                      ),
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback(
                            (_) => {searchController.clear()});
                      },
                    ),
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.black)),
                controller: searchController,
                onChanged: (val) {
                  setState(() {
                    query = val;
                  });
                },
              ),
              Expanded(
                child: buildResults(query),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildResults(String query) {
    //Search by username and name: put in lower case avoiding problems
    final List<UserModel> searchResults = query.isEmpty
        ? []
        : userList
            .where((UserModel user) =>
                (user.name.contains(query.toLowerCase()) ||
                    (user.name.contains(query.toLowerCase()))))
            .toList();

    return ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: ((context, index) {
          return ListTile(
            title: Text(searchResults[index].name),
            leading:
                new Image.asset('assets/images/${searchResults[index].avatar}'),
            onTap: () async {
              String cuid2 = searchResults[index].uid;
              await firebaseHelper.createConversation(cuid2);
              Navigator.pop(context);
            },
          );
        }));
  }
}
