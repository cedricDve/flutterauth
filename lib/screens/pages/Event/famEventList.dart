import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homeEvent.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'package:flutter_familly_app/commons/utils.dart';

class HomeFamEvents extends StatefulWidget {
  @override
  _HomeFamEventsState createState() => _HomeFamEventsState();
}

class _HomeFamEventsState extends State<HomeFamEvents> {
  String fid;
  FirebaseHelper _firebaseHelper = FirebaseHelper();
  @override
  void initState() {
    super.initState();
    _firebaseHelper.getFID().then((value) {
      setState(() {
        fid = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Family Events')),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CreateFamEvent()));
          },
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('families')
              .doc(fid)
              .collection('fam-events')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.event_note),
                      title:
                          Text("${snapshot.data.docs[index].data()['title']}"),
                      subtitle: Text(
                          "${snapshot.data.docs[index].data()['description']}"),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventHomePage(
                                      eventId: snapshot.data.docs[index]
                                          .data()['eventId'], title: snapshot.data.docs[index].data()['title'],description: snapshot.data.docs[index].data()['description'],
                                    )));
                      },
                    );
                  });
            } else {
              return LinearProgressIndicator();
            }
          },
        ));
  }
}

class CreateFamEvent extends StatefulWidget {
  @override
  _CreateFamEventState createState() => _CreateFamEventState();
}

class _CreateFamEventState extends State<CreateFamEvent> {
  TextEditingController _titel = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseHelper _firebaseHelper = FirebaseHelper();
  String fid;
  String eventId;

  @override
  void initState() {
    super.initState();
    _firebaseHelper.getFID().then((value) {
      setState(() {
        fid = value;
      });
    });
  }

  void uploadData(String title, String desc) async {
    setState(() {
      eventId = Utils.getRandomString(8) + Random().nextInt(500).toString();
    });
    await firestore
        .collection("families")
        .doc(fid)
        .collection('fam-events')
        .doc(eventId)
        .set({
      'title': title,
      'description': desc,
      'eventId': eventId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Family Event')),
      body: Container(
          child: Column(
        children: <Widget>[
          FlatButton.icon(
              onPressed: () {
                if (_titel.text.isEmpty || _description.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please enter a title and a description");
                } else {
                  uploadData(_titel.text.trim(), _description.text.trim());
                  Navigator.pop(context);
                }
              },
              icon: const Icon(
                Icons.create,
                color: Colors.green,
              ),
              label:
                  const Text("Create family-event and stat adding Images !")),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
                controller: _titel,
                decoration: InputDecoration(hintText: "Give a Title")),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
                controller: _description,
                decoration: InputDecoration(hintText: "Give a Description")),
          ),
          FlatButton(
            child: const Text("Create event"),
            color: Colors.blueAccent,
              onPressed: () {
                if (_titel.text.isEmpty || _description.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please enter a title and a description");
                } else {
                  uploadData(_titel.text.trim(), _description.text.trim());
                  Navigator.of(context).pop();
                }
              },
              )
        ],
      )),
    );
  }
}
