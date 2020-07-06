import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosapp/dto/user_achievement.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/user_model.dart';

class UserAchievementModel {
  UserModel sender;
  AchievementModel achievement;
  String comment;
  Timestamp date;

  UserAchievementModel._({
    this.sender,
    this.comment,
    this.date,
    this.achievement,
  });

  factory UserAchievementModel.fromUserAchievement(
      UserAchievement userAchievement) {
    return UserAchievementModel._(
        sender: UserModel.fromUserReference(userAchievement.sender),
        achievement: AchievementModel.fromRelatedAchievement(
            userAchievement.achievement),
        comment: userAchievement.comment,
        date: userAchievement.date);
  }
}
