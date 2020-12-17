import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:flutter_familly_app/screens/pages/Event/famEventDetails.dart';
import 'package:flutter_familly_app/models/famEvent.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  FirebaseHelper _firebaseHelper = FirebaseHelper();
  String fid;
  FamEvent events;
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
      appBar: AppBar(
        title: Text("Family Events"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('families')
            .doc(fid)
            .collection('events')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length >= 1)
              return PageView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  print((snapshot.data.docs[index].data()));
                  events = FamEvent(
                    title: snapshot.data.docs[index].data()['title'],
                    position: snapshot.data.docs[index].data()['position'],
                    images: snapshot.data.docs[index].data()['images'],
                    eventImage: snapshot.data.docs[index].data()['event_image'],
                    description:
                        snapshot.data.docs[index].data()['description'],
                    owner: snapshot.data.docs[index].data()['owner'],
                    members: snapshot.data.docs[index].data()['members'],
                    date: snapshot.data.docs[index].data()['date'],
                  );

                  return GestureDetector(
                    onTap: () {
                      print(events);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FamEventDetails(
                            events: events,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.network(
                            snapshot.data.docs.elementAt(index)['event_image']),
                        Text(
                              snapshot.data.docs.elementAt(index)['title'],
                              style: TextStyle(fontSize: 30.0),
                            ) ??
                            Text(""),
                        Text(
                              snapshot.data.docs.elementAt(index)['owner'],
                              style: TextStyle(fontSize: 20.0),
                            ) ??
                            Text(""),
                        Text(
                              snapshot.data.docs
                                  .elementAt(index)['description'],
                              style: TextStyle(fontSize: 20.0),
                            ) ??
                            Text(""),
                        Text(
                              snapshot.data.docs.elementAt(index)['date'],
                              style: TextStyle(fontSize: 20.0),
                            ) ??
                            Text(""),
                      ],
                    ),
                  );
                },
              );
            else {
              return Container(
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.error,
                      color: Colors.grey[700],
                      size: 64,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        'There are no Family Events',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )),
              );
            }
          } else {
            debugPrint('Loading...');
            return Center(
              child: Text('Loading...'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //navigate
        },
      ),
    );
  }
}
