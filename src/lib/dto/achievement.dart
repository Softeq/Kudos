import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/dto/team_reference.dart';
import 'package:kudosapp/dto/user_reference.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/achievement_owner_model.dart';

/// Achievements collection
@immutable
class Achievement extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String imageName;
  final TeamReference teamReference;
  final UserReference userReference;
  final Set<String> members;
  final Set<String> owners;
  final bool isActive;

  Achievement._({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.imageUrl,
    @required this.teamReference,
    @required this.userReference,
    @required this.imageName,
    @required this.isActive,
    @required this.members,
    @required this.owners,
  });

  factory Achievement.fromDocument(DocumentSnapshot x) {
    return Achievement._(
      id: x.documentID,
      name: x.data["name"],
      description: x.data["description"],
      imageUrl: x.data["image_url"],
      imageName: x.data["image_name"],
      teamReference: TeamReference.fromMap(x.data["team"]),
      userReference: UserReference.fromMap(x.data["user"]),
      owners: Set<String>.from(x.data["owners"]),
      members: Set<String>.from(x.data["members"]),
      isActive: x.data["is_active"],
    );
  }

  factory Achievement.fromModel(
    AchievementModel model, {
    bool isActive,
    AchievementOwnerModel newOwner,
  }) {
    UserReference userReference;
    TeamReference teamReference;
    Set<String> members;
    Set<String> owners;

    if (newOwner != null) {
      userReference =
          newOwner.user != null ? UserReference.fromModel(newOwner.user) : null;
      teamReference =
          newOwner.team != null ? TeamReference.fromModel(newOwner.team) : null;
      members = newOwner.team?.members?.map((u) => u.id)?.toSet();
      owners = newOwner.team?.owners?.map((u) => u.id)?.toSet();
    } else {
      userReference = model.owner.user != null
          ? UserReference.fromModel(model.owner.user)
          : null;
      teamReference = model.owner.team != null
          ? TeamReference.fromModel(model.owner.team)
          : null;
      members = model.owner?.team?.members?.map((u) => u.id)?.toSet();
      owners = model.owner?.team?.owners?.map((u) => u.id)?.toSet();
    }

    return Achievement._(
      id: model.id,
      name: model.name,
      description: model.description,
      imageUrl: model.imageUrl,
      imageName: model.imageName,
      teamReference: teamReference,
      userReference: userReference,
      members: members,
      owners: owners,
      isActive: isActive ?? true,
    );
  }

  Map<String, dynamic> toMap({
    @required bool all,
    bool metadata,
    bool image,
    bool owner,
    bool isActive,
  }) {
    final map = new Map<String, Object>();

    if (metadata) {
      map.putIfAbsent("name", () => this.name);
      map.putIfAbsent("description", () => this.description);
    }

    if (image) {
      map.putIfAbsent("image_url", () => this.imageUrl);
      map.putIfAbsent("image_name", () => this.imageName);
    }

    if (owner) {
      map.putIfAbsent(
          "team", () => teamReference == null ? null : teamReference.toMap());
      map.putIfAbsent(
          "user", () => userReference == null ? null : userReference.toMap());
      map.putIfAbsent("members", () => this.members);
      map.putIfAbsent("owners", () => this.owners);
    }

    if (isActive) {
      map.putIfAbsent("is_active", () => this.isActive);
    }

    return map;
  }

  @override
  List<Object> get props => [id];
}
