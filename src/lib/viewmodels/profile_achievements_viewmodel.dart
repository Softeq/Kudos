import 'package:kudosapp/models/user_achievement_collection.dart';
import 'package:kudosapp/models/user_achievement_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class ProfileAchievementsViewModel extends BaseViewModel {
  final _authService = locator<BaseAuthService>();
  final _achievementsService = locator<AchievementsService>();

  final String _userId;
  final achievements = List<UserAchievementCollection>();

  bool get isMyProfile => _userId == _authService.currentUser.id;

  ProfileAchievementsViewModel(this._userId) {
    _initialize();
  }

  void _initialize() async {
    isBusy = true;

    final allUserAchievements =
        await _achievementsService.getReceivedAchievements(_userId);

    achievements.clear();
    achievements.addAll(_merge(allUserAchievements));
    achievements.sort((x, y) => y.latestDateTime.compareTo(x.latestDateTime));

    isBusy = false;
  }

  Iterable<UserAchievementCollection> _merge(
    List<UserAchievementModel> userAchievements,
  ) {
    final Map<String, UserAchievementCollection> _map = {};

    for (final x in userAchievements) {
      final id = x.achievement.id;
      if (_map.containsKey(id)) {
        _map[id] = _map[id].addAchievement(x);
      } else {
        _map[id] = UserAchievementCollection.single(x);
      }
    }

    return _map.values;
  }
}
