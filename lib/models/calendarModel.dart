import 'dart:convert';

class CalendarEvent {
  final String title;
  final String id;
  final String description;
  final DateTime date;
  final String userId;
  final bool isPublic;
  final String groupMeetingCode;
  CalendarEvent({
    this.title,
    this.id,
    this.description,
    this.date,
    this.userId,
    this.isPublic,
    this.groupMeetingCode,
  });

  CalendarEvent copyWith({
    String title,
    String id,
    String description,
    DateTime date,
    String userId,
    bool isPublic,
    String groupMeetingCode,
  }) {
    return CalendarEvent(
      title: title ?? this.title,
      id: id ?? this.id,
      description: description ?? this.description,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      isPublic: isPublic ?? this.isPublic,
      groupMeetingCode: groupMeetingCode ?? this.groupMeetingCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'description': description,
      'date': date?.millisecondsSinceEpoch,
      'userId': userId,
      'isPublic': isPublic,
      'groupMeetingCode': groupMeetingCode,
    };
  }

//Map
  factory CalendarEvent.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return CalendarEvent(
      title: map['title'] as String,
      id: map['id'] as String,
      description: map['description'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      userId: map['userId'] as String,
      isPublic: map['isPublic'] as bool,
    );
  }
  // DS : DataSnapshot
  factory CalendarEvent.fromDS(String id,Map<String, dynamic> map) {
    if (map == null) return null;
  
    return CalendarEvent(
      title: map['title'] as String,
      id: id,
      description: map['description'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      userId: map['userId'] as String,
      isPublic: map['isPublic'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CalendarEvent.fromJson(String source) => CalendarEvent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CalendarEvent(title: $title, id: $id, description: $description, date: $date, userId: $userId, isPublic: $isPublic)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is CalendarEvent &&
      o.title == title &&
      o.id == id &&
      o.description == description &&
      o.date == date &&
      o.userId == userId &&
      o.isPublic == isPublic;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      id.hashCode ^
      description.hashCode ^
      date.hashCode ^
      userId.hashCode ^
      isPublic.hashCode;
  }
}
