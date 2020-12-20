import 'dart:convert';

class FamMemberModel {
  final String id;
  final String avatar;
  final String fid;
  final String name;
  FamMemberModel({
    this.id,
    this.avatar,
    this.fid,
    this.name,
  });

  FamMemberModel copyWith({
    String id,
    String avatar,
    String fid,
    String name,
  }) {
    return FamMemberModel(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      fid: fid ?? this.fid,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'avatar': avatar,
      'fid': fid,
      'name': name,
    };
  }

  factory FamMemberModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FamMemberModel(
      id: map['id'] as String,
      avatar: map['avatar'] as String,
      fid: map['fid'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FamMemberModel.fromJson(String source) =>
      FamMemberModel.fromMap(json.decode(source)as Map<String, dynamic>);

  @override
  String toString() =>
      'FamMemberModel(id: $id, avatar: $avatar, fid: $fid, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FamMemberModel &&
        o.id == id &&
        o.avatar == avatar &&
        o.fid == fid &&
        o.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ avatar.hashCode;
}
