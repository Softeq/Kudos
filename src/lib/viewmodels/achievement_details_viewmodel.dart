import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/achievement_holder.dart';
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

  List<AchievementHolder> _achievementHolders;
  AchievementItemViewModel _achievementViewModel;
  double _statisticsValue = 0;

  AchievementItemViewModel get achievementViewModel => _achievementViewModel;
  List<AchievementHolder> get achievementHolders => _achievementHolders;

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
    _achievementHolders = await _achievementsService.getAchievementHolders(achievementViewModel.model.id);
    var allUsers = await _peopleService.getAllUsers();
    _statisticsValue = allUsers.length == 0 ? 0 : _achievementHolders.length / allUsers.length;
    isBusy = false;
  }

  @override
  void dispose() {
    _achievementViewModel.dispose();
    super.dispose();
  }
}
