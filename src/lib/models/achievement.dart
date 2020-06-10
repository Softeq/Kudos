import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/team.dart';
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
  final String imageName;
  final bool canBeModifiedByCurrentUser;
  final bool canBeSentByCurrentUser;
  final bool isActive;

  Achievement._({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.imageUrl,
    @required this.teamReference,
    @required this.userReference,
    @required this.imageName,
    @required this.canBeModifiedByCurrentUser,
    @required this.canBeSentByCurrentUser,
    @required this.isActive,
  });

  factory Achievement.fromDocument(DocumentSnapshot x) {
    return Achievement._(
      id: x.documentID,
      name: x.data["name"],
      description: x.data["description"],
      imageUrl: x.data["image_url"],
      teamReference: TeamReference.fromMap(x.data["team"]),
      userReference: UserReference.fromMap(x.data["user"]),
      imageName: x.data["image_name"],
      canBeModifiedByCurrentUser: false,
      canBeSentByCurrentUser: false,
      isActive : x.data["is_active"],
    );
  }

  factory Achievement.empty() {
    return Achievement._(
      description: null,
      name: null,
      imageUrl: null,
      id: null,
      teamReference: null,
      userReference: null,
      imageName: null,
      isActive: true,
      canBeModifiedByCurrentUser: null,
      canBeSentByCurrentUser: null,
    );
  }

  Achievement copy({
    String name,
    String description,
    String imageUrl,
    TeamReference teamReference,
    UserReference userReference,
    String imageName,
    bool canBeModifiedByCurrentUser,
    bool canBeSentByCurrentUser,
    bool isActive,
  }) {
    return Achievement._(
      id: this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      teamReference: teamReference ?? this.teamReference,
      userReference: userReference ?? this.userReference,
      imageName: imageName ?? this.imageName,
      canBeModifiedByCurrentUser:
          canBeModifiedByCurrentUser ?? this.canBeModifiedByCurrentUser,
      canBeSentByCurrentUser:
          canBeSentByCurrentUser ?? this.canBeSentByCurrentUser,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap(Team team) {
    final map = {
      "name": name,
      "description": description,
      "image_url": imageUrl,
      "team": teamReference == null ? null : teamReference.toMap(),
      "user": userReference == null ? null : userReference.toMap(),
      "image_name": imageName,
      "is_active": isActive,
    };

    if (team != null) {
      map["members"] = team.members.map((x) => x.id).toList();
      map["owners"] = team.owners.map((x) => x.id).toList();
    }

    return map;
  }
}
