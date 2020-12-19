import 'dart:convert';

class FamMemberModel {
  final String id;
  final String avatar;
  FamMemberModel({
    this.id,
    this.avatar,
  });

  FamMemberModel copyWith({
    String id,
    String avatar,
  }) {
    return FamMemberModel(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'avatar': avatar,
    };
  }

  factory FamMemberModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FamMemberModel(
      id: map['id'],
      avatar: map['avatar'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FamMemberModel.fromJson(String source) =>
      FamMemberModel.fromMap(json.decode(source));

  @override
  String toString() => 'FamMemberModel(id: $id, avatar: $avatar)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FamMemberModel && o.id == id && o.avatar == avatar;
  }

  @override
  int get hashCode => id.hashCode ^ avatar.hashCode;
}
