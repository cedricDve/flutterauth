import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_familly_app/models/user.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'package:flutter_familly_app/commons/utils.dart';
import 'package:intl/intl.dart';

//-------------------------------FAQ PAGE -------------------------------------------------------
class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("FAQ Page"),
      ),
      body: FaqList(),
    );
  }
}

//-------------------------------FAQ LIST -------------------------------------------------------
class FaqList extends StatefulWidget {
  @override
  _FaqListState createState() => _FaqListState();
}

class _FaqListState extends State<FaqList> {
  Future _data;

  Future getFaqs() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot qs = await firestore.collection("faq").get();
    //return all documents
    return qs.docs;
  }

  @override
  void initState() {
    // TO LOAD MAKE ONCE THE DATASNAPSHOT
    super.initState();
    setState(() {
      _data = getFaqs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //getting data from firestore => FUTURE
      child: FutureBuilder(
        future: getFaqs(),
        builder: (_, snapshot) {
          //check if connection with firestore is set => avoid errors
          if (!snapshot.hasData) return LinearProgressIndicator();
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const Text("Loading ...."),
            );
          } else {
            //connected => data ready
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FaqDetailsPage(
                                    faq: snapshot.data[index],
                                    docRef: "question$index",
                                  )));
                    },
                    title: Text(snapshot.data[index].data()['title']),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.help,
                        color: Colors.blue[200],
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}

//-------------------------------FAQ DETAILS-PAGE -------------------------------------------------------
class FaqDetailsPage extends StatefulWidget {
  final DocumentSnapshot faq;
  final String docRef;
  const FaqDetailsPage({this.faq, this.docRef});

  @override
  _FaqDetailsPageState createState() => _FaqDetailsPageState();
}

class _FaqDetailsPageState extends State<FaqDetailsPage> {
  DateTime dateTimeNow = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ / Help '),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  CreateFaqComment(faq: widget.faq, docRef: widget.docRef)));
        },
      ),
      body: Container(
          child: Column(
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.faq.data()['title'],
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.faq.data()["description"],
                style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
              ),
            ),
          ),
          Divider(
            height: 4,
            color: Colors.green,
          ),
          new SizedBox(
            height: 300,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('faq')
                  .doc(widget.docRef)
                  .collection('faqComments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (contex, index) {
                        return Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                              width: 3,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            leading: Icon(
                              Icons.comment,
                              size: 35,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "Object: ${snapshot.data.docs[index].data()['title']}"),
                            ),
                            subtitle: Column(
                              children: [
                                Text(
                                    "Description: ${snapshot.data.docs[index].data()['description']}",
                                    style: TextStyle(color: Colors.black)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "Posted at: ${snapshot.data.docs[index].data()['posted_at'].toDate().toString()}"),
                                ),
                                Divider(),
                              ],
                            ),
                            onTap: () {},
                          ),
                        );
                      });
                } else {
                  return LinearProgressIndicator();
                }
              },
            ),
          ),
        ],
      )),
    );
  }
}

class CreateFaqComment extends StatefulWidget {
  final String docRef;
  final DocumentSnapshot faq;

  const CreateFaqComment({Key key, this.docRef, this.faq}) : super(key: key);
  @override
  _CreateFaqCommentState createState() => _CreateFaqCommentState();
}

class _CreateFaqCommentState extends State<CreateFaqComment> {
  TextEditingController _titel = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseHelper _firebaseHelper = FirebaseHelper();
  String fid;
  String cuid;
  String eventId;

  @override
  void initState() {
    super.initState();
    _firebaseHelper.getFID().then((value) {
      setState(() {
        fid = value;
      });
    });
    _firebaseHelper.getCurrentUser().then((user) {
      setState(() {
        cuid = user.uid;
      });
    });
  }

  void uploadData(String title, String desc) async {
    setState(() {
      eventId = Utils.getRandomString(8) + Random().nextInt(500).toString();
    });

    await firestore
        .collection("faq")
        .doc(widget.docRef)
        .collection('faqComments')
        .doc()
        .set({
      'title': title,
      'description': desc,
      'user_id': cuid,
      'posted_at': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Commment to FAQ "),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(50.0),
              child: const Text(
                  "Write something that could help other users, or give us some feedback"),
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "${widget.faq.data()['title']}",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            new Container(
              padding: const EdgeInsets.all(25.0),
              height: 250,
              child: Image.asset('assets/images/faqq.jpg'),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                  controller: _titel,
                  decoration: InputDecoration(
                    hintText: "Give a Title",
                    hintMaxLines: 5,
                  )),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                  controller: _description,
                  decoration: InputDecoration(
                    hintText: "Give a Description",
                    hintMaxLines: 5,
                  )),
            ),
            const SizedBox(
              height: 15.0,
            ),
            FlatButton(
              padding: const EdgeInsets.all(7.0),
              color: Colors.green[400],
              child: const Text("Add", style: TextStyle(fontSize: 30)),
              onPressed: () {
                if (_titel.text.isEmpty || _description.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please enter a title and a description");
                } else {
                  uploadData(_titel.text.trim(), _description.text.trim());
                  Navigator.pop(context);
                }
              },
            ),
          ],
        )),
      ),
    );
  }
}
