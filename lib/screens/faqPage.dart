import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_familly_app/models/user.dart';

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
                              builder: (context) =>
                                  FaqDetailsPage(faq: snapshot.data[index])));
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
  const FaqDetailsPage({this.faq});

  @override
  _FaqDetailsPageState createState() => _FaqDetailsPageState();
}

class _FaqDetailsPageState extends State<FaqDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQ"),
      ),
      body: Container(
          child: Card(
        child: ListTile(
          title: Text(widget.faq.data()['title']),
          subtitle: Text(widget.faq.data()["description"]),
        ),
      )),
    );
  }
}
