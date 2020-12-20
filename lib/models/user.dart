import 'dart:convert';

class UserModel {
  final String uid;
  final String fid;
  final String name;
  final String email;
  final String role;
  final String birthday;
  final String avatar;
  final bool isFamily; //
  final bool isAdmin; //
  final String uniqueId;
  UserModel({
    this.uid,
    this.fid,
    this.name,
    this.email,
    this.role,
    this.birthday,
    this.avatar,
    this.isFamily,
    this.isAdmin,
    this.uniqueId,
  });

  UserModel copyWith({
    String uid,
    String fid,
    String name,
    String email,
    String role,
    String birthday,
    String avatar,
    bool isFamily,
    bool isAdmin,
    String uniqueId,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fid: fid ?? this.fid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      birthday: birthday ?? this.birthday,
      avatar: avatar ?? this.avatar,
      isFamily: isFamily ?? this.isFamily,
      isAdmin: isAdmin ?? this.isAdmin,
      uniqueId: uniqueId ?? this.uniqueId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fid': fid,
      'name': name,
      'email': email,
      'role': role,
      'birthday': birthday,
      'avatar': avatar,
      'isFamily': isFamily,
      'isAdmin': isAdmin,
      'uniqueId': uniqueId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserModel(
      uid: map['uid'] as String,
      fid: map['fid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      birthday: map['birthday'] as String,
      avatar: map['avatar'] as String,
      isFamily: map['isFamily'] as bool,
      isAdmin: map['isAdmin'] as bool,
      uniqueId: map['uniqueId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    // ignore: prefer_double_quotes
    return 'UserModel(uid: $uid, fid: $fid,name: $name, email: $email, role: $role,birthday: $birthday, avatar: $avatar,isFamily: $isFamily, isAdmin: $isAdmin,uniqueId: $uniqueId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserModel &&
        o.uid == uid &&
        o.fid == fid &&
        o.name == name &&
        o.email == email &&
        o.role == role &&
        o.birthday == birthday &&
        o.avatar == avatar &&
        o.isFamily == isFamily &&
        o.isAdmin == isAdmin &&
        o.uniqueId == uniqueId;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        fid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        role.hashCode ^
        birthday.hashCode ^
        avatar.hashCode ^
        isFamily.hashCode ^
        isAdmin.hashCode ^
        uniqueId.hashCode;
  }
}
