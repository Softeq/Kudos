import 'dart:core';
import 'dart:io';

import 'package:kudosapp/dto/achievement.dart';
import 'package:kudosapp/dto/related_achievement.dart';
import 'package:kudosapp/models/access_level.dart';
import 'package:kudosapp/models/achievement_owner_model.dart';
import 'package:kudosapp/models/team_member_model.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_access_level.dart';
import 'package:kudosapp/models/user_model.dart';

class AchievementModel {
  String id;
  String name;
  String description;
  String imageUrl;
  String imageName;
  File imageFile;
  AchievementOwnerModel owner;
  AccessLevel accessLevel;
  Map<String, TeamMemberModel> teamMembers;
  bool isActive;

  AchievementModel._({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.imageName,
    this.owner,
    this.accessLevel,
    this.teamMembers,
    this.isActive = true,
  });

  factory AchievementModel.empty() => AchievementModel._();

  factory AchievementModel.fromAchievement(Achievement achievement) {
    return AchievementModel._(
      id: achievement.id,
      name: achievement.name,
      description: achievement.description,
      imageUrl: achievement.imageUrl,
      imageName: achievement.imageName,
      teamMembers: achievement.teamMembers == null
          ? null
          : Map.fromIterable(achievement.teamMembers,
              key: (item) => item.id,
              value: (item) => TeamMemberModel.fromTeamMember(item)),
      owner: achievement.team != null
          ? AchievementOwnerModel.fromTeam(
              TeamModel.fromTeamReference(achievement.team))
          : AchievementOwnerModel.fromUser(
              UserModel.fromUserReference(achievement.user)),
      accessLevel: (AccessLevel.values[achievement.accessLevel]),
      isActive: achievement.isActive,
    );
  }

  factory AchievementModel.fromRelatedAchievement(
      RelatedAchievement relatedAchievement) {
    return AchievementModel._(
      id: relatedAchievement.id,
      name: relatedAchievement.name,
      imageUrl: relatedAchievement.imageUrl,
    );
  }

  void updateWithModel(AchievementModel achievement) {
    id = achievement.id;
    name = achievement.name;
    description = achievement.description;
    imageUrl = achievement.imageUrl;
    imageName = achievement.imageName;
    imageFile = achievement.imageFile;
    owner = achievement.owner;
    accessLevel = achievement.accessLevel;
    teamMembers = achievement.teamMembers;
    isActive = achievement.isActive;
  }

  bool _isTeamMember(String userId) =>
      teamMembers?.containsKey(userId) ?? false;

  bool _isTeamAdmin(String userId) =>
      _isTeamMember(userId) &&
      teamMembers[userId].accessLevel == UserAccessLevel.admin;

  bool _isAchievementOwner(String userId) => (owner?.id == userId) ?? false;

  bool canBeViewedByUser(String userId) =>
      _isTeamMember(userId) ||
      accessLevel == AccessLevel.public ||
      accessLevel == AccessLevel.protected;

  bool canBeModifiedByUser(String userId) =>
      isActive && (_isAchievementOwner(userId) || _isTeamAdmin(userId));

  bool canBeSentByUser(String userId) =>
      isActive &&
      (_isAchievementOwner(userId) ||
          _isTeamMember(userId) ||
          accessLevel == AccessLevel.public);

  bool canBeSentToUser(String senderId, String userId) {
    var result = canBeSentByUser(senderId);

    if (accessLevel == AccessLevel.private) {
      result = result && teamMembers.values.any((x) => x.user.id == userId);
    }

    return result;
  }
}
