import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'addImages.dart';

class EventHomePage extends StatefulWidget {
  final String eventId;

  const EventHomePage({this.eventId});

  @override
  _EventHomePageState createState() => _EventHomePageState();
}

class _EventHomePageState extends State<EventHomePage> {
  FirebaseHelper _firebaseHelper = FirebaseHelper();
  String fid;
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
      appBar: AppBar(title: Text('Event')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddImage(
                    eventId: widget.eventId,
                  )));
        },
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('families')
            .doc(fid)
            .collection('imageURLs')
            .where('eventId', isEqualTo: widget.eventId)
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: EdgeInsets.all(4),
                  child: GridView.builder(
                      itemCount: snapshot.data.documents.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(3),
                          child: FadeInImage.memoryNetwork(
                              fit: BoxFit.cover,
                              placeholder: kTransparentImage,
                              image: snapshot.data.documents[index].get('url')),
                        );
                      }),
                );
        },
      ),
    );
  }
}
