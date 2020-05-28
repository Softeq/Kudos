import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/team_reference.dart';
import 'package:kudosapp/models/user_reference.dart';

@immutable
class Achievement {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final TeamReference teamReference;
  final UserReference userReference;

  Achievement._({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.imageUrl,
    @required this.teamReference,
    @required this.userReference,
  });

  factory Achievement.fromDocument(DocumentSnapshot x) {
    return Achievement._(
      id: x.documentID,
      name: x.data["name"],
      description: x.data["description"],
      imageUrl: x.data["image_url"],
      teamReference: TeamReference.fromMap(x.data["team"]),
      userReference: UserReference.fromMap(x.data["user"])
    );
  }

  factory Achievement.empty() {
    return Achievement._(
      description: null,
      name: null,
      imageUrl: null,
      id: null,
      teamReference: null,
      userReference: null
    );
  }

  Achievement copy({
    String name,
    String description,
    String imageUrl,
    TeamReference teamReference,
    UserReference userReference,
    String imageName,
  }) {
    return Achievement._(
      id: this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      teamReference: teamReference ?? this.teamReference,
      userReference: userReference ?? this.userReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "image_url": imageUrl,
      "team": teamReference == null ? null : teamReference.toMap(),
      "user": userReference == null ? null : userReference.toMap(),
    };
  }
}
