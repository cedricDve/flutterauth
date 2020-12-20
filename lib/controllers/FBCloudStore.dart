import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_familly_app/commons/const.dart';
import 'package:flutter_familly_app/commons/utils.dart';
import 'package:flutter_familly_app/services/firebaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FBCloudMessaging.dart';

class FBCloudStore {
  static Future<void> sendPostInFirebase(String postID, String postContent,
      MyProfileData userProfile, String postImageURL) async {
    final FirebaseHelper _firebaseHelper = FirebaseHelper();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String postFCMToken;
    if (userProfile.myFCMToken == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      postFCMToken = prefs.get('FCMToken');
    } else {
      postFCMToken = userProfile.myFCMToken;
    }
    String cuid =
        await _firebaseHelper.getCurrentUser().then((user) => user.uid);
    DocumentSnapshot ds = await _firestore.collection("users").doc(cuid).get();
    print(ds.get('fid'));
    print(cuid);
    FirebaseFirestore.instance
        .collection('families')
        .doc(ds.get('fid'))
        .collection('thread')
        .doc(postID)
        .set({
      'postID': postID,
      'userName': userProfile.myName,
      'userId': cuid,
      'userThumbnail': userProfile.myThumbnail,
      'postTimeStamp': DateTime.now().millisecondsSinceEpoch,
      'postContent': postContent,
      'postImage': postImageURL,
      'postLikeCount': 0,
      'postCommentCount': 0,
      'FCMToken': postFCMToken
    });
  }

  static Future<void> sendReportUserToFB(context, String reason,
      String userName, String postId, String content, String reporter) async {
    try {
      FirebaseFirestore.instance.collection('report').doc().set({
        'reason': reason,
        'author': userName,
        'postId': postId,
        'content': content,
        'reporter': reporter
      });
    } catch (e) {
      print('Report post error');
    }
  }

  static Future<void> likeToPost(
      String postID, MyProfileData userProfile, bool isLikePost) async {
    final FirebaseHelper _firebaseHelper = FirebaseHelper();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String cuid =
        await _firebaseHelper.getCurrentUser().then((user) => user.uid);
    DocumentSnapshot ds = await _firestore.collection("users").doc(cuid).get();

    if (isLikePost) {
      DocumentReference likeReference = FirebaseFirestore.instance
          .collection('families')
          .doc(ds.get('fid'))
          .collection('thread')
          .doc(postID)
          .collection('like')
          .doc(userProfile.myName);
      await FirebaseFirestore.instance
          .runTransaction((Transaction myTransaction) async {
        myTransaction.delete(likeReference);
      });
    } else {
      await FirebaseFirestore.instance
          .collection('families')
          .doc(ds.get('fid'))
          .collection('thread')
          .doc(postID)
          .collection('like')
          .doc(userProfile.myName)
          .set({
        'userName': userProfile.myName,
        'userThumbnail': userProfile.myThumbnail,
      });
    }
  }

  static Future<void> updatePostLikeCount(DocumentSnapshot postData,
      bool isLikePost, MyProfileData myProfileData) async {
    postData.reference
        .update({'postLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});
    if (!isLikePost) {
      await FBCloudMessaging.instance.sendNotificationMessageToPeerUser(
          '${myProfileData.myName} likes your post',
          '${myProfileData.myName}',
          postData['FCMToken']);
    }
  }

  static Future<void> updatePostCommentCount(
    DocumentSnapshot postData,
  ) async {
    postData.reference.update({'postCommentCount': FieldValue.increment(1)});
  }

  static Future<void> updateCommentLikeCount(DocumentSnapshot postData,
      bool isLikePost, MyProfileData myProfileData) async {
    postData.reference.update(
        {'commentLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});
    if (!isLikePost) {
      await FBCloudMessaging.instance.sendNotificationMessageToPeerUser(
          '${myProfileData.myName} likes your comment',
          '${myProfileData.myName}',
          postData['FCMToken']);
    }
  }

  static Future<void> commentToPost(
      String toUserID,
      String toCommentID,
      String postID,
      String commentContent,
      MyProfileData userProfile,
      String postFCMToken) async {
    String commentID =
        Utils.getRandomString(8) + Random().nextInt(500).toString();
    String myFCMToken;
    if (userProfile.myFCMToken == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      myFCMToken = prefs.get('FCMToken');
    } else {
      myFCMToken = userProfile.myFCMToken;
    }
    final FirebaseHelper _firebaseHelper = FirebaseHelper();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String cuid =
        await _firebaseHelper.getCurrentUser().then((user) => user.uid);
    DocumentSnapshot ds = await _firestore.collection("users").doc(cuid).get();

    FirebaseFirestore.instance
        .collection('families')
        .doc(ds.get('fid'))
        .collection('thread')
        .doc(postID)
        .collection('comment')
        .doc(commentID)
        .set({
      'toUserID': toUserID,
      'commentID': commentID,
      'toCommentID': toCommentID,
      'userName': userProfile.myName,
      'userThumbnail': userProfile.myThumbnail,
      'commentTimeStamp': DateTime.now().millisecondsSinceEpoch,
      'commentContent': commentContent,
      'commentLikeCount': 0,
      'FCMToken': myFCMToken
    });
    await FBCloudMessaging.instance.sendNotificationMessageToPeerUser(
        commentContent, '${userProfile.myName} was commented', postFCMToken);
  }
}
