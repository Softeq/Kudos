import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/team_reference.dart';

@immutable
class Achievement {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String teamId;
  final TeamReference teamReference;
  final String userId;

  Achievement._({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.imageUrl,
    @required this.teamId,
    @required this.teamReference,
    @required this.userId,
  });

  factory Achievement.fromDocument(DocumentSnapshot x) {
    return Achievement._(
      id: x.documentID,
      name: x.data["name"],
      description: x.data["description"],
      imageUrl: x.data["image_url"],
      teamId: x.data["team_id"],
      teamReference: TeamReference.fromMap(x.data["team"]),
      userId: x.data["user_id"],
    );
  }

  factory Achievement.empty() {
    return Achievement._(
      description: null,
      name: null,
      imageUrl: null,
      id: null,
      teamReference: null,
      teamId: null,
      userId: null,
    );
  }

  Achievement copy({
    String name,
    String description,
    String imageUrl,
    String teamId,
    TeamReference teamReference,
    String userId,
  }) {
    return Achievement._(
      id: this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      teamId: teamId ?? this.teamId,
      teamReference: teamReference ?? this.teamReference,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "image_url": imageUrl,
      "team_id": teamId,
      "team": teamReference == null ? null : teamReference.toMap(),
      "user_id": userId,
    };
  }
}
