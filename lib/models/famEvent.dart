import 'dart:convert';

import 'package:flutter/foundation.dart';

class FamEvent {
  final String date;
  final String owner;
  final String title;
  final String eventImage;
  final String description;
  final int position;
  final List members;
  final List images;
  FamEvent({
    this.date,
    this.owner,
    this.title,
    this.eventImage,
    this.description,
    this.position,
    this.members,
    this.images,
  });

  FamEvent copyWith({
    String date,
    String owner,
    String title,
    String eventImage,
    String description,
    int position,
    List<String> members,
    List<String> images,
  }) {
    return FamEvent(
      date: date ?? this.date,
      owner: owner ?? this.owner,
      title: title ?? this.title,
      eventImage: eventImage ?? this.eventImage,
      description: description ?? this.description,
      position: position ?? this.position,
      members: members ?? this.members,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'owner': owner,
      'title': title,
      'eventImage': eventImage,
      'description': description,
      'position': position,
      'members': members,
      'images': images,
    };
  }

  factory FamEvent.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FamEvent(
      date: map['date'],
      owner: map['owner'],
      title: map['title'],
      eventImage: map['eventImage'],
      description: map['description'],
      position: map['position'],
      members: List<String>.from(map['members']),
      images: List<String>.from(map['images']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FamEvent.fromJson(String source) =>
      FamEvent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FamEvent(date: $date, owner: $owner, title: $title, eventImage: $eventImage, description: $description, position: $position, members: $members, images: $images)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FamEvent &&
        o.date == date &&
        o.owner == owner &&
        o.title == title &&
        o.eventImage == eventImage &&
        o.description == description &&
        o.position == position &&
        listEquals(o.members, members) &&
        listEquals(o.images, images);
  }

  @override
  int get hashCode {
    return date.hashCode ^
        owner.hashCode ^
        title.hashCode ^
        eventImage.hashCode ^
        description.hashCode ^
        position.hashCode ^
        members.hashCode ^
        images.hashCode;
  }
}
