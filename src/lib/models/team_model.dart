import 'dart:io';

import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/dto/team_reference.dart';
import 'package:kudosapp/models/access_level.dart';
import 'package:kudosapp/models/team_member_model.dart';
import 'package:kudosapp/models/user_access_level.dart';

class TeamModel {
  String id;
  String name;
  String description;
  String imageUrl;
  String imageName;
  File imageFile;
  Map<String, TeamMemberModel> members;
  AccessLevel accessLevel;
  bool isActive;

  TeamModel._({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.imageName,
    this.members,
    this.accessLevel,
    this.isActive = true,
  });

  factory TeamModel.empty() {
    return TeamModel._();
  }

  factory TeamModel.fromTeam(Team team) {
    return TeamModel._(
      id: team.id,
      name: team.name,
      description: team.description,
      imageUrl: team.imageUrl,
      imageName: team.imageName,
      members: Map.fromIterable(
        team.members,
        key: (item) => item.id,
        value: (item) => TeamMemberModel.fromTeamMember(item),
      ),
      accessLevel: (AccessLevel.values[team.accessLevel]),
      isActive: team.isActive,
    );
  }

  factory TeamModel.fromTeamReference(TeamReference teamReference) {
    return TeamModel._(
      id: teamReference.id,
      name: teamReference.name,
    );
  }

  void updateWithModel(TeamModel team) {
    id = team.id;
    name = team.name;
    description = team.description;
    imageUrl = team.imageUrl;
    imageName = team.imageName;
    imageFile = team.imageFile;
    members = team.members;
    accessLevel = team.accessLevel;
    isActive = team.isActive;
  }

  bool get isOfficialTeam => accessLevel == AccessLevel.official;

  bool isTeamAdmin(String userId) =>
      isTeamMember(userId) &&
      members[userId].accessLevel == UserAccessLevel.admin;

  bool isTeamMember(String userId) => members?.containsKey(userId) ?? false;

  bool canBeModifiedByUser(String userId) => isActive && isTeamAdmin(userId);

  bool canBeViewedByUser(String userId) =>
      isActive &&
      (isTeamMember(userId) ||
          accessLevel == AccessLevel.official ||
          accessLevel == AccessLevel.public ||
          accessLevel == AccessLevel.protected);
}
