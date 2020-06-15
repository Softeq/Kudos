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

  static bool _contains(List<dynamic> list, value) {
    if (list == null) {
      return false;
    }

    return List<String>.from(list).contains(value);
  }

  factory Achievement.fromDocument(DocumentSnapshot x, String userId) {
    var isActive = x.data["is_active"];
    var members = x.data["members"];
    var userReference = UserReference.fromMap(x.data["user"]);
    var owners = x.data["owners"];
    var ownedByUser = userReference?.id == userId;
    var canBeModifiedByCurrentUser =
        isActive && (ownedByUser || _contains(owners, userId));
    var canBeSentByCurrentUser = canBeModifiedByCurrentUser ||
        (isActive && (ownedByUser || _contains(members, userId)));

    return Achievement._(
      id: x.documentID,
      name: x.data["name"],
      description: x.data["description"],
      imageUrl: x.data["image_url"],
      imageName: x.data["image_name"],
      teamReference: TeamReference.fromMap(x.data["team"]),
      userReference: userReference,
      canBeModifiedByCurrentUser: canBeModifiedByCurrentUser,
      canBeSentByCurrentUser: canBeSentByCurrentUser,
      isActive: isActive,
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

  static Map<String, dynamic> createMap({
    String name,
    String description,
    String imageUrl,
    String imageName,
    TeamReference teamReference,
    UserReference userReference,
    bool isActive,
    Team team,
  }) {
    var map = Map<String, dynamic>();

    if (name != null) {
      map["name"] = name;
    }

    if (imageUrl != null) {
      map["image_url"] = imageUrl;
    }

    if (imageName != null) {
      map["image_name"] = imageName;
    }

    if (description != null) {
      map["description"] = description;
    }

    if (isActive != null) {
      map["is_active"] = isActive;
    }

    if (teamReference != null) {
      map["user"] = null;
      map["team"] = teamReference.toMap();
    }

    if (userReference != null) {
      map["team"] = null;
      map["user"] = userReference.toMap();
    }

    if (team != null) {
      map["members"] = team.members.map((x) => x.id).toList();
      map["owners"] = team.owners.map((x) => x.id).toList();
    }

    return map;
  }
}
