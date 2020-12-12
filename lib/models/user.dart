class UserModel {
  String uid;
  String fid;
  String name;
  String email;
  String role;
  String birthday;
  String avatar;
  bool isFamily; //
  bool isAdmin; //

  UserModel(
      {this.uid,
      this.fid,
      this.name,
      this.email,
      this.role,
      this.birthday,
      this.avatar,
      this.isFamily,
      this.isAdmin});

  Map toMap(UserModel user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['fid'] = user.fid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['role'] = user.role;
    data['birthday'] = user.birthday;
    data['avatar'] = user.avatar;
    data['isFamily'] = user.isFamily;
    data['isAdmin'] = user.isAdmin;
    return data;
  }

//parse the map and create a user object
  UserModel.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.fid = mapData['fid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.role = mapData['role'];
    this.birthday = mapData['birthday'];
    this.avatar = mapData['avatar'];
    this.isFamily = mapData['isFamily'];
    this.isAdmin = mapData['isAdmin'];
  }
}
