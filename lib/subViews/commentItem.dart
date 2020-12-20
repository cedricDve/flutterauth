import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_familly_app/commons/const.dart';
import 'package:flutter_familly_app/commons/utils.dart';


class CommentItem extends StatefulWidget{
  final DocumentSnapshot data;
  final MyProfileData myData;
  final Size size;
  final ValueChanged<MyProfileData> updateMyDataToMain;
  final ValueChanged<List<String>> replyComment;
  CommentItem({this.data,this.size,this.myData,this.updateMyDataToMain,this.replyComment});
  @override State<StatefulWidget> createState() => _CommentItem();
}

class _CommentItem extends State<CommentItem>{

  MyProfileData _currentMyData;
  @override
  void initState() {
    _currentMyData = widget.myData;
    super.initState();
  }

  void _updateLikeCount(bool isLikePost) async{
    MyProfileData _newProfileData = await Utils.updateLikeCount(widget.data,isLikePost,widget.myData,widget.updateMyDataToMain,false);
    setState(() {
      _currentMyData = _newProfileData;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Helooooooooo");
    print(widget.data['commentContent']);
    print("Zeuuuuubuiiiibibibibi");
    return Padding(
      padding: widget.data['toCommentID'] == null ? EdgeInsets.all(8.0) : EdgeInsets.fromLTRB(34.0,8.0,8.0,8.0),
      child: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0,2.0,10.0,2.0),
                child: Container(
                    width: widget.data['toCommentID'] == null ? 48 : 40,
                    height: widget.data['toCommentID'] == null ? 48 : 40,
                    child: Image.asset('assets/images/${widget.data['userThumbnail']}')
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(widget.data['userName'] as String,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:6.0),
                            child: widget.data['toCommentID'] == null ? Text(widget.data['commentContent'] as String,maxLines: 1,) :
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  //TextSpan(text: widget.data['toUserID'], style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[800])),
                                  TextSpan(text: widget.data['commentContent'] as String, style: TextStyle(color:Colors.black)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    width: widget.size.width- (widget.data['toCommentID'] == null ? 90 : 110),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(
                          Radius.circular(15.0)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0,top: 4.0),
                    child: Container(
                      width: widget.size.width * 0.38,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(Utils.readTimestamp(widget.data['commentTimeStamp'] as int)),
                          GestureDetector(
                              onTap: () => _updateLikeCount(_currentMyData.myLikeCommnetList != null && _currentMyData.myLikeCommnetList.contains(widget.data['commentID']) ? true : false),
                              child: Text('Like',
                                  style:TextStyle(fontWeight: FontWeight.bold,color:_currentMyData.myLikeCommnetList != null && _currentMyData.myLikeCommnetList.contains(widget.data['commentID']) ? Colors.blue[900] : Colors.grey[700]))
                          ),
                          GestureDetector(
                              onTap: (){
                                widget.replyComment([widget.data['userName'] as String,widget.data['commentID'] as String,widget.data['FCMToken'] as String]);
//                                _replyComment(widget.data['userName'],widget.data['commentID'],widget.data['FCMToken']);
                                print('leave comment of commnet');
                              },
                              child: Text('Reply',style:TextStyle(fontWeight: FontWeight.bold,color:Colors.grey[700]))
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          widget.data['commentLikeCount'] as int> 0 
          ? Positioned(
            bottom: 10,
            right:0,
            child: Card(
                elevation:2.0,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.favorite,size: 14,color: Colors.blue[900],),
                      Text('${widget.data['commentLikeCount']}',
                      style:TextStyle(fontSize: 14)),
                    ],
                  ),
                )
            ),
          ) : Container(),
        ],
      ),
    );
  }
}