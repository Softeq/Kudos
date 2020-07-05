import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/database/achievements_service.dart';
import 'package:kudosapp/services/image_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class EditAchievementViewModel extends BaseViewModel {
  final _eventBus = locator<EventBus>();
  final _imageService = locator<ImageService>();
  final _achievementsService = locator<AchievementsService>();

  final AchievementModel _initialAchievement;
  final AchievementModel _achievement = new AchievementModel();
  final TeamModel _team;
  final UserModel _user;

  bool _isImageLoading;

  bool get isImageLoading => _isImageLoading;
  set isImageLoading(bool value) {
    if (_isImageLoading != value) {
      _isImageLoading = value;
      notifyListeners();
    }
  }

  String get pageTitle =>
      _achievement.id == null ? localizer().create : localizer().edit;

  String get name => _achievement.name ?? "";

  set name(String value) {
    _achievement.name = value;
    notifyListeners();
  }

  String get description => _achievement.description ?? "";

  set description(String value) {
    _achievement.description = value;
    notifyListeners();
  }

  File get imageFile => _achievement.imageFile;
  String get imageUrl => _achievement.imageUrl;

  EditAchievementViewModel._(this._initialAchievement, this._team, this._user) {
    _isImageLoading = false;
    _achievement.updateWithModel(_initialAchievement);
  }

  factory EditAchievementViewModel.createTeamAchievement(TeamModel team) =>
      EditAchievementViewModel._(null, team, null);

  factory EditAchievementViewModel.createUserAchievement(UserModel user) =>
      EditAchievementViewModel._(null, null, user);

  factory EditAchievementViewModel.editAchievement(
          AchievementModel achievementModel) =>
      EditAchievementViewModel._(achievementModel, null, null);

  void pickFile(BuildContext context) async {
    if (isImageLoading) {
      return;
    }

    isImageLoading = true;
    _achievement.imageFile =
        await _imageService.pickImage(context) ?? _achievement.imageFile;
    isImageLoading = false;
  }

  Future<void> save() async {
    AchievementModel updatedAchievement;

    try {
      isBusy = true;
      if (_achievement.id == null) {
        updatedAchievement = await _achievementsService.createAchievement(
          achievement: _achievement,
          user: _user,
          team: _team,
        );
      } else {
        updatedAchievement = await _achievementsService.updateAchievement(
            achievement: _achievement);
      }
    } finally {
      isBusy = false;
    }

    if (updatedAchievement != null) {
      _initialAchievement?.updateWithModel(updatedAchievement);
      _eventBus.fire(AchievementUpdatedMessage(updatedAchievement));
    }
  }
}
