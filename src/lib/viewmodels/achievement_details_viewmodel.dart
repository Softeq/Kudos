import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/viewmodels/achievement_item_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class AchievementDetailsViewModel extends BaseViewModel {

  final AchievementsService _achievementsService =
      locator<AchievementsService>();
  final PeopleService _peopleService =
      locator<PeopleService>();

  AchievementItemViewModel _achievementViewModel;
  double _statisticsValue;

  AchievementItemViewModel get achievementViewModel => _achievementViewModel;

  double get statisticsValue => _statisticsValue;

  AchievementDetailsViewModel() {
    isBusy = true;
  }

  Future<void> initialize(Achievement achievement) async {
    _achievementViewModel = AchievementItemViewModel(
      achievement: achievement,
      category: null,
    );

    await loadStatistics();
  }

  Future<void> loadStatistics() async {
    // Number of users with this badge divided by the total number of users
    var achivementUsers = await _achievementsService.getAchievementHolders(achievementViewModel.model.id);
    var allUsers = await _peopleService.getAllUsers();
    _statisticsValue = allUsers.length == 0 ? 0 : achivementUsers.length / allUsers.length;
    isBusy = false;
  }

  @override
  void dispose() {
    _achievementViewModel.dispose();
    super.dispose();
  }
}