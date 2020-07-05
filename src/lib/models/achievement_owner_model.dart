import 'package:flutter/material.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_model.dart';

enum AchievementOwnerType { user, team }

@immutable
class AchievementOwnerModel {
  final TeamModel _team;
  final UserModel _user;
  final AchievementOwnerType _type;

  TeamModel get team => _team;
  UserModel get user => _user;

  String get id => _type == AchievementOwnerType.user ? user?.id : team?.id;
  String get name => _type == AchievementOwnerType.user ? user?.name : team?.name;
  String get imageUrl => _type == AchievementOwnerType.user ? user?.imageUrl : team?.imageUrl;

  AchievementOwnerType get type => _type;

  AchievementOwnerModel._(this._team, this._user, this._type);

  factory AchievementOwnerModel.fromTeam(TeamModel team){
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
