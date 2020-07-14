import 'dart:core';
import 'dart:io';

import 'package:kudosapp/dto/achievement.dart';
import 'package:kudosapp/dto/related_achievement.dart';
import 'package:kudosapp/models/achievement_owner_model.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_model.dart';

class AchievementModel {
  String id;
  String name;
  String description;
  String imageUrl;
  String imageName;
  File imageFile;
  AchievementOwnerModel owner;
  Set<String> admins;
  Set<String> members;

  AchievementModel._({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.imageName,
    this.owner,
    this.admins,
    this.members,
  });

  factory AchievementModel.empty() => AchievementModel._();

  factory AchievementModel.fromAchievement(Achievement achievement) {
    return AchievementModel._(
      id: achievement.id,
      name: achievement.name,
      description: achievement.description,
      imageUrl: achievement.imageUrl,
      imageName: achievement.imageName,
      admins: achievement.owners,
      members: achievement.members,
      owner: achievement.team != null
          ? AchievementOwnerModel.fromTeam(
              TeamModel.fromTeamReference(achievement.team))
          : AchievementOwnerModel.fromUser(
              UserModel.fromUserReference(achievement.user)),
    );
  }

  factory AchievementModel.fromRelatedAchievement(
      RelatedAchievement relatedAchievement) {
    return AchievementModel._(
        id: relatedAchievement.id,
        name: relatedAchievement.name,
        imageUrl: relatedAchievement.imageUrl);
  }

  void updateWithModel(AchievementModel achievement) {
    id = achievement.id;
    name = achievement.name;
    description = achievement.description;
    imageUrl = achievement.imageUrl;
    imageName = achievement.imageName;
    imageFile = achievement.imageFile;
    owner = achievement.owner;
  }

  bool canBeModifiedByUser(String userId) =>
      owner.id == userId || (admins?.contains(userId) ?? false);
  bool canBeSentByUser(String userId) =>
      owner.id == userId || (members?.contains(userId) ?? false);
}
