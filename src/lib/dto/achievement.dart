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
  final TeamReference team;
  final UserReference user;
  final Set<String> members;
  final Set<String> owners;
  final bool isActive;

  Achievement._({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.imageUrl,
    @required this.team,
    @required this.user,
    @required this.imageName,
    @required this.isActive,
    @required this.members,
    @required this.owners,
  });

  factory Achievement.fromJson(Map<String, dynamic> map, String id) {
    return map == null
        ? null
        : Achievement._(
            id: id ?? map["id"],
            name: map["name"],
            description: map["description"],
            imageUrl: map["image_url"],
            imageName: map["image_name"],
            team: TeamReference.fromJson(map["team"], null),
            user: UserReference.fromJson(map["user"], null),
            owners:
                map["owners"] == null ? null : Set<String>.from(map["owners"]),
            members: map["members"] == null
                ? null
                : Set<String>.from(map["members"]),
            isActive: map["is_active"],
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
      team: teamReference,
      user: userReference,
      members: members,
      owners: owners,
      isActive: isActive ?? true,
    );
  }

  Map<String, dynamic> toJson({
    bool addAll,
    bool addMetadata = false,
    bool addImage = false,
    bool addOwner = false,
    bool addIsActive = false,
  }) {
    final map = new Map<String, Object>();

    if (addAll || addMetadata) {
      map.putIfAbsent("name", () => this.name);
      map.putIfAbsent("description", () => this.description);
    }

    if (addAll || addImage) {
      map.putIfAbsent("image_url", () => this.imageUrl);
      map.putIfAbsent("image_name", () => this.imageName);
    }

    if (addAll || addOwner) {
      map.putIfAbsent("team", () => team == null ? null : team.toJson());
      map.putIfAbsent("user", () => user == null ? null : user.toJson());
      map.putIfAbsent("members", () => this.members?.toList());
      map.putIfAbsent("owners", () => this.owners?.toList());
    }

    if (addAll || addIsActive) {
      map.putIfAbsent("is_active", () => this.isActive);
    }

    return map;
  }

  @override
  List<Object> get props => [id];
}
