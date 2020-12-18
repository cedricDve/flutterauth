class ConversationModel {
  String cid;
  int updateDate;
  List<String> members;
  List<String> memberSender;

  ConversationModel({
    this.cid,
    this.updateDate,
    this.members,
    this.memberSender,
  });

  Map toMap(ConversationModel conversation) {
    var data = Map<String, dynamic>();
    data['cid'] = conversation.cid;
    data['updateDate'] = conversation.updateDate;
    data['members'] = conversation.members;
    data['memberSender'] = conversation.memberSender;
    return data;
  }

//parse the map and create a user object
  ConversationModel.fromMap(Map<String, dynamic> mapData) {
    this.cid = mapData['cid'];
    this.updateDate = mapData['updateDate'];
    this.members = mapData['members'];
    this.memberSender = mapData['memberSender'];
  }
}