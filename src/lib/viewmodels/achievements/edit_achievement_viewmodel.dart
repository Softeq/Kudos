import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/helpers/image_loading.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/achievement_owner_model.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/services/image_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class EditAchievementViewModel extends BaseViewModel with ImageLoading {
  final _eventBus = locator<EventBus>();
  final _imageService = locator<ImageService>();
  final _achievementsService = locator<AchievementsService>();

  final AchievementModel _initialAchievement;
  final AchievementModel _achievement = AchievementModel.empty();

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

  EditAchievementViewModel._(
      this._initialAchievement, TeamModel team, UserModel user) {
    if (_initialAchievement != null) {
      _achievement.updateWithModel(_initialAchievement);
    }
    if (team != null) {
      _achievement.owner = AchievementOwnerModel.fromTeam(team);
    } else if (user != null) {
      _achievement.owner = AchievementOwnerModel.fromUser(user);
    }
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

      if (name.isEmpty) {
        throw ArgumentError.notNull("name");
      }

      if (description.isEmpty) {
        throw ArgumentError.notNull("description");
      }

      if (_achievement.id == null) {
        updatedAchievement =
            await _achievementsService.createAchievement(_achievement);
      } else {
        updatedAchievement =
            await _achievementsService.updateAchievement(_achievement);
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
