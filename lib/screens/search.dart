import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/models/user.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:flutter_familly_app/widgets/customChat.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseHelper firebaseHelper = FirebaseHelper();
  List<UserModel> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();
  //search instantly: performance => fetch once the data => then check for the data
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseHelper.getCurrentUser().then((User user) {
      firebaseHelper.fetchAllUsers(user).then((List<UserModel> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.blue,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      //make appbar "bigger"
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
              controller: searchController,
              //get type texted for instant search
              onChanged: (val) {
                setState(() {
                  query = val;
                });
              },
              //let user clear the searchbox
              cursorColor: Colors.black,
              autofocus: true,
              style: TextStyle(color: Colors.blue, fontSize: 40),
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close, color: Colors.blue),
                    onPressed: () {
                      //clear the search Textfield
                      //searched for a solution and found this on git, if I directly call searchController.clear I had an error
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => {searchController.clear()});
                    },
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.black))),
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
                (user.username.contains(query.toLowerCase()) ||
                    (user.name.contains(query.toLowerCase()))))
            .toList();
    return ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: ((context, index) {
          UserModel searchedUser = UserModel(
            uid: searchResults[index].uid,
            name: searchResults[index].name,
            username: searchResults[index].username,
            avatar: searchResults[index].avatar,
          );
          //return same view as chat-feed
          return CustomChat(
            title: Text(searchedUser.username,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(searchedUser.avatar),
              backgroundColor: Colors.black,
            ),
            subtitle: Text(searchedUser.name,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
            mini: false,
            onTap: () {},
            onLongPress: () {},
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: searchAppBar(context),
        //Results from search
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: buildResults(query),
        ));
  }
}