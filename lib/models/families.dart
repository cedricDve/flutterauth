class FamilyModel{

  String fid;
  String fname;
  String avatar;
  List<String> members;
  List<String> membersRequest;

  FamilyModel({
    this.fid,
    this.fname,
    this.avatar,
    this.members,
    this.membersRequest,
  });

  Map toMap(FamilyModel user) {
  var data = Map<String, dynamic>();
  data['fid'] = user.fid;
  data['fname'] = user.fname;
  data['avatar'] = user.avatar;
  data['members'] = user.members;
  data['membersRequest'] = user.membersRequest;
  return data;
  }

//parse the map and create a user object
  FamilyModel.fromMap(Map<String, dynamic> mapData) {
  this.fid = mapData['uid'];
  this.fname = mapData['fname'];
  this.avatar = mapData['avatar'];
  this.members = mapData['members'];
  this.membersRequest = mapData['membersRequest'];
  }

}