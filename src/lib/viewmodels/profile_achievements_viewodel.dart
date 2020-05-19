import 'package:kudosapp/models/user_achievement.dart';
import 'package:kudosapp/models/user_achievement_collection.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class ProfileAchievementsViewModel extends BaseViewModel {
  final _achievementsService = locator<AchievementsService>();
  final String _userId;

  List<UserAchievementCollection> _achievements = [];

  ProfileAchievementsViewModel(this._userId);

  List<UserAchievementCollection> get achievements => _achievements;

  Future<void> initialize() async {
    isBusy = true;

    final allUserAchievements =
        await _achievementsService.getUserAchievements(_userId);

    _achievements = _merge(allUserAchievements);

    isBusy = false;
  }

  List<UserAchievementCollection> _merge(
    List<UserAchievement> userAchievements,
  ) {
    final Map<String, UserAchievementCollection> _map = {};

    for (final x in userAchievements) {
      final id = x.achievement.id;
      if (_map.containsKey(id)) {
        _map[id] = _map[id].increaseCount();
      } else {
        _map[id] = UserAchievementCollection.single(x);
      }
    }

    return _map.values.toList();
  }
}
