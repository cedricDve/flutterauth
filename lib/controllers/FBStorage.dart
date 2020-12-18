import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FBStorage {
  static Future<String> uploadPostImages(
      {@required String postID, @required File postImageFile}) async {
    try {
      String fileName = 'assets/images/$postID/postImage';
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(postImageFile);
      TaskSnapshot storageTaskSnapshot = await uploadTask;
      String postIageURL = await storageTaskSnapshot.ref.getDownloadURL();
      return postIageURL;
    } catch (e) {
      return null;
    }
  }

  static Future<String> uploadEventImages(
      {@required String eventID, @required File eventImageFile}) async {
    try {
      String fileName = 'assets/images/$eventID/postImage';
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(eventImageFile);
      TaskSnapshot storageTaskSnapshot = await uploadTask;
      String eventIageURL = await storageTaskSnapshot.ref.getDownloadURL();
      return eventIageURL;
    } catch (e) {
      return null;
    }
  }
}
