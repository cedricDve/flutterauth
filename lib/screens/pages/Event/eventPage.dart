import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:flutter_familly_app/screens/pages/Event/famEventDetails.dart';
import 'package:flutter_familly_app/models/famEvent.dart';
import 'dart:math';
import 'package:flutter_familly_app/commons/utils.dart';
import 'package:flutter_familly_app/controllers/FBCloudStore.dart';
import 'package:flutter_familly_app/controllers/FBStorage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'dart:io';
import 'package:image_crop/image_crop.dart';
import 'package:image_cropper/image_cropper.dart';

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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewFamilyEvent(events: events)));
        },
      ),
    );
  }
}

class NewFamilyEvent extends StatefulWidget {
  final FamEvent events;

  const NewFamilyEvent({this.events});
  @override
  State<StatefulWidget> createState() => _NewFamilyEvent();
}

class _NewFamilyEvent extends State<NewFamilyEvent> {
  TextEditingController writingTextController = TextEditingController();
  TextEditingController titleTextController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  FocusNode writingTextFocus = FocusNode();
  bool _isLoading = false;
  File _postImageFile;
  File _file;
  File _sample;
  File _lastCropped;
  File _pickedImage;
  final cropKey = GlobalKey<CropState>();

  @override
  void dispose() {
    super.dispose();
    _file?.delete();
    _sample?.delete();
    _lastCropped?.delete();
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          displayArrows: false,
          focusNode: _nodeText1,
        ),
        KeyboardActionsItem(
          displayArrows: false,
          focusNode: writingTextFocus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () {
                  print('Select Image');
                  _showPickOptionsDialog(context);
                  print('Selected');
                },
                child: Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add_photo_alternate, size: 28),
                      Text(
                        "Add Image",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }

  void _postToFB() async {
    setState(() {
      _isLoading = true;
    });
    String postID = Utils.getRandomString(8) + Random().nextInt(500).toString();
    String postImageURL;
    if (_postImageFile != null) {
      postImageURL = await FBStorage.uploadPostImages(
          postID: postID, postImageFile: _postImageFile);
    }
    FBCloudStore.sendEventInFirebase(titleTextController.text,
        writingTextController.text, widget.events, postImageURL ?? 'NONE');

    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Writing Post'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
              onPressed: () => _postToFB(),
              child: Text(
                'Post',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: Stack(
        children: <Widget>[
          KeyboardActions(
            config: _buildConfig(context),
            child: Column(
              children: <Widget>[
                Container(
                    width: size.width,
                    height: size.height -
                        MediaQuery.of(context).viewInsets.bottom -
                        80,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14.0, left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    width: 40,
                                    height: 40,
                                    child: Image.asset(
                                        'assets/images/${widget.events.eventImage}')),
                              ),
                              Text(
                                widget.events.owner,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                          TextField(
                            autofocus: true,
                            focusNode: writingTextFocus,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Writing anything.',
                              hintMaxLines: 2,
                            ),
                            controller: titleTextController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                          TextFormField(
                            autofocus: true,
                            focusNode: writingTextFocus,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Writing anything.',
                              hintMaxLines: 4,
                            ),
                            controller: writingTextController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                          _postImageFile != null
                              ? Image.file(
                                  _postImageFile,
                                  fit: BoxFit.fill,
                                )
                              : Container(),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Utils.loadingCircle(_isLoading),
        ],
      ),
    );
  }

  _loadPicker(ImageSource source) async {
    File picked = await ImagePicker.pickImage(source: source);
    if (picked != null) {
      _cropImage(picked);
    }
  }

  _cropImage(File picked) async {
    File cropped = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Colors.red,
        toolbarColor: Colors.blue[200],
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.white,
      ),
      sourcePath: picked.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio4x3,
      ],
      maxWidth: 800,
    );
    if (cropped != null) {
      setState(() {
        _pickedImage = cropped;
        _postImageFile = _pickedImage;
      });
    }
  }

  void _showPickOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("Pick from Gallery"),
              onTap: () {
                _loadPicker(ImageSource.gallery);
              },
            ),
            ListTile(
              title: Text("Take a pictuer"),
              onTap: () {
                _loadPicker(ImageSource.camera);
              },
            )
          ],
        ),
      ),
    );
  }
}
