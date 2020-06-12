import 'package:event_bus/event_bus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/services/file_service.dart';
import 'package:kudosapp/viewmodels/achievement_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class EditAchievementViewModel extends BaseViewModel {
  final AchievementViewModel achievementViewModel;
  final Team _team;
  final User _user;
  final _achievementsService = locator<AchievementsService>();
  final _eventBus = locator<EventBus>();
  final bool _create;

  EditAchievementViewModel._(
      Achievement achievement, Team team, User user)
      :
        achievementViewModel = AchievementViewModel(achievement),
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
    achievementViewModel.dispose();
    super.dispose();
  }

  Future<bool> pickFile() async {
    if (achievementViewModel.imageViewModel.isBusy) {
      return true;
    }
    achievementViewModel.imageViewModel.update(isBusy: true);

    var file = await FilePicker.getFile(type: FileType.image);
    final fileService = locator<FileService>();
    var isValid = await fileService.isFileSizeValid(file);

    achievementViewModel.imageViewModel
        .update(isBusy: false, file: isValid ? file : null);

    return isValid;
  }

  Future<void> save() async {
    Achievement result;
    if (_create) {
      result = await _achievementsService.createAchievement(
          name: achievementViewModel.title,
          description: achievementViewModel.description,
          file: achievementViewModel.imageViewModel.file,
          user: _user,
          team: _team);
    } else {
      result = await _achievementsService.updateAchievement(
          id: achievementViewModel.achievement.id,
          name: achievementViewModel.title,
          description: achievementViewModel.description,
          file: achievementViewModel.imageViewModel.file);
    }
    _eventBus.fire(AchievementUpdatedMessage(result));
  }
}
