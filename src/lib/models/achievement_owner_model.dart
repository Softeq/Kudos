import 'package:flutter/material.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_model.dart';

enum AchievementOwnerType { user, team }

@immutable
class AchievementOwnerModel {
  final TeamModel team;
  final UserModel user;
  final AchievementOwnerType type;

  String get id => type == AchievementOwnerType.user ? user?.id : team?.id;
  String get name =>
      type == AchievementOwnerType.user ? user?.name : team?.name;
  String get imageUrl =>
      type == AchievementOwnerType.user ? user?.imageUrl : team?.imageUrl;

  AchievementOwnerModel._(this.team, this.user, this.type);

  factory AchievementOwnerModel.fromTeam(TeamModel team) {
    return AchievementOwnerModel._(
      team,
      null,
      AchievementOwnerType.team,
    );
  }

  factory AchievementOwnerModel.fromUser(UserModel user) {
    return AchievementOwnerModel._(
      null,
      user,
      AchievementOwnerType.user,
    );
  }
}
