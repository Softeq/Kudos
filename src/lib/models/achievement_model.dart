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
  bool canBeModifiedByCurrentUser = false;
  bool canBeSentByCurrentUser = false;

  AchievementModel.fromAchievement(Achievement achievement) {
    _updateWithAchievement(achievement);
  }

  AchievementModel.fromRelatedAchievement(
      RelatedAchievement relatedAchievement) {
    id = relatedAchievement.id;
    name = relatedAchievement.name;
    imageUrl = relatedAchievement.imageUrl;
  }

  AchievementModel({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.imageName,
    this.canBeModifiedByCurrentUser,
    this.canBeSentByCurrentUser,
  });

  void _updateWithAchievement(Achievement achievement) {
    id = achievement.id;
    name = achievement.name;
    description = achievement.description;
    imageUrl = achievement.imageUrl;
    imageName = achievement.imageName;
    canBeModifiedByCurrentUser = achievement.canBeModifiedByCurrentUser;
    canBeSentByCurrentUser = achievement.canBeSentByCurrentUser;
    if (achievement.teamReference != null) {
      owner = AchievementOwnerModel.fromTeam(
          TeamModel.fromTeamReference(achievement.teamReference));
    } else {
      owner = AchievementOwnerModel.fromUser(
          UserModel.fromUserReference(achievement.userReference));
    }
  }

  void updateWithModel(AchievementModel achievement) {
    id = achievement.id;
    name = achievement.name;
    description = achievement.description;
    imageUrl = achievement.imageUrl;
    imageName = achievement.imageName;
    imageFile = achievement.imageFile;
    owner = achievement.owner;
    canBeModifiedByCurrentUser = achievement.canBeModifiedByCurrentUser;
    canBeSentByCurrentUser = achievement.canBeSentByCurrentUser;
  }
}
