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
    Map<String, UserAchievementCollection> _map = {};

    for (final x in userAchievements) {
      final id = x.achievement.id;
      if (_map.containsKey(id)) {
        final y = _map[id];
        _map[id] = UserAchievementCollection(y.userAchievement, y.count + 1);
      } else {
        _map[id] = UserAchievementCollection(x, 1);
      }
    }

    final group = _map.values.toList();

    return group;
  }
}
