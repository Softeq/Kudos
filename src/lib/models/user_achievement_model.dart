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

  UserAchievementModel.fromUserAchievement(UserAchievement userAchievement) {
    sender = UserModel.fromUserReference(userAchievement.sender);
    achievement = AchievementModel.fromRelatedAchievement(userAchievement.achievement);
    comment = userAchievement.comment;
    date = userAchievement.date;
  }

  UserAchievementModel({
    this.sender,
    this.comment,
    this.date,
    this.achievement,
  });
}
