class UserModel {
  String uid;
  String name;
  String email;
  String username;
  String role;
  String birthday;
  String avatar;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.role,
    this.birthday,
    this.avatar,
  });

  Map toMap(UserModel user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['username'] = user.username;
    data['role'] = user.role;
    data['birthday'] = user.birthday;
    data['avatar'] = user.avatar;
    return data;
  }

//parse the map and create a user object
  UserModel.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.role = mapData['role'];
    this.birthday = mapData['birthday'];
    this.avatar = mapData['avatar'];
  }
}
