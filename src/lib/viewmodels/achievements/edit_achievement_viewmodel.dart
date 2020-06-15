import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/dto/achievement.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/database/achievements_service.dart';
import 'package:kudosapp/services/image_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class EditAchievementViewModel extends BaseViewModel {
  final AchievementModel achievementModel;
  final Team _team;
  final User _user;
  final _achievementsService = locator<AchievementsService>();
  final _imageService = locator<ImageService>();
  final _eventBus = locator<EventBus>();
  final bool _create;

  EditAchievementViewModel._(Achievement achievement, Team team, User user)
      : achievementModel = AchievementModel(achievement),
        _team = team,
        _user = null,
        _create = achievement == null;

  factory EditAchievementViewModel.createTeamAchievement(Team team) {
    return EditAchievementViewModel._(null, team, null);
  }

  factory EditAchievementViewModel.createUserAchievement(User user) {
    return EditAchievementViewModel._(null, null, user);
  }

  factory EditAchievementViewModel.editAchievement(Achievement achievement) {
    return EditAchievementViewModel._(achievement, null, null);
  }

  @override
  void dispose() {
    achievementModel.dispose();
    super.dispose();
  }

  void pickFile(BuildContext context) async {
    if (achievementModel.imageViewModel.isBusy) {
      return;
    }
    achievementModel.imageViewModel.update(isBusy: true);

    var file = await _imageService.pickImage(context);

    achievementModel.imageViewModel.update(isBusy: false, file: file);
  }

  Future<void> save() async {
    Achievement result;
    if (_create) {
      result = await _achievementsService.createAchievement(
          name: achievementModel.title,
          description: achievementModel.description,
          file: achievementModel.imageViewModel.file,
          user: _user,
          team: _team);
    } else {
      result = await _achievementsService.updateAchievement(
          id: achievementModel.achievement.id,
          name: achievementModel.title,
          description: achievementModel.description,
          file: achievementModel.imageViewModel.file);
    }
    _eventBus.fire(AchievementUpdatedMessage(result));
  }
}
