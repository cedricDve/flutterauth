class MessageModel {
  String mid;
  String message;
  int time;
  String sender;

  MessageModel({
    this.mid,
    this.message,
    this.time,
    this.sender,
  });

  Map toMap(MessageModel message) {
    var data = Map<String, dynamic>();
    data['mid'] = message.mid;
    data['message'] = message.message;
    data['time'] = message.time;
    data['sender'] = message.sender;
    return data;
  }

//parse the map and create a user object
  MessageModel.fromMap(Map<String, dynamic> mapData) {
    this.mid = mapData['mid'] as String;
    this.message = mapData['message'] as String;
    this.time = mapData['time'] as int;
    this.sender = mapData['sender'] as String;
  }
}