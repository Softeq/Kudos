import 'package:event_bus/event_bus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/viewmodels/achievement_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class EditAchievementViewModel extends BaseViewModel {
  final AchievementViewModel achievementViewModel;
  final Team _team;
  final User _user;
  final _achievementsService = locator<AchievementsService>();
  final _eventBus = locator<EventBus>();

  EditAchievementViewModel(Achievement achievement, Team team, User user)
      : assert(achievement != null),
        achievementViewModel = AchievementViewModel(achievement),
        _team = team,
        _user = user;

  @override
  void dispose() {
    achievementViewModel.dispose();
    super.dispose();
  }

  void pickFile() async {
    if (achievementViewModel.isFileLoading) {
      return;
    }
    achievementViewModel.isFileLoading = true;

    var file = await FilePicker.getFile(type: FileType.image);

    achievementViewModel.isFileLoading = false;

    if (file != null) {
      achievementViewModel.file = file;
    }
  }

  Future<void> save() async {
    var result = await _achievementsService.createOrUpdate(
      achievement: achievementViewModel.getModifiedAchievement(),
      file: achievementViewModel.file,
      team: _team,
      user: _user,
    );
    _eventBus.fire(AchievementUpdatedMessage(result));
  }
}
