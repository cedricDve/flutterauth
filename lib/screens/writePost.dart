import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/commons/const.dart';
import 'package:flutter_familly_app/commons/utils.dart';
import 'package:flutter_familly_app/controllers/FBCloudStore.dart';
import 'package:flutter_familly_app/controllers/FBStorage.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

class WritePost extends StatefulWidget {
  final MyProfileData myData;
  WritePost({this.myData});
  @override
  State<StatefulWidget> createState() => _WritePost();
}

class _WritePost extends State<WritePost> {
  TextEditingController writingTextController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  FocusNode writingTextFocus = FocusNode();
  bool _isLoading = false;
  File _postImageFile;
  final cropKey = GlobalKey<CropState>();
  File _file;
  File _sample;
  File _lastCropped;
  File _pickedImage;

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
    FBCloudStore.sendPostInFirebase(postID, writingTextController.text,
        widget.myData, postImageURL ?? 'NONE');

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
                                        'assets/images/${widget.myData.myThumbnail}')),
                              ),
                              Text(
                                widget.myData.myName,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            color: Colors.black,
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
        toolbarColor: Colors.red,
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
    print("Daniel");
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
