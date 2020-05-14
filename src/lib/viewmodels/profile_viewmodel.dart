import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/models/user_achievement.dart';
import 'package:kudosapp/models/user_achievement_collection.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class ProfileViewModel extends BaseViewModel {
  final AchievementsService _achievementsService =
      locator<AchievementsService>();
  final User user;

  List<UserAchievementCollection> _achievements = [];

  ProfileViewModel(this.user);

  Future<List<UserAchievementCollection>> get achievements async {
    if (_achievements.isEmpty) {
      final allUserAchievements =
          await _achievementsService.getUserAchievements(user.id);

      _achievements = _merge(allUserAchievements);
    }
    return _achievements;
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
