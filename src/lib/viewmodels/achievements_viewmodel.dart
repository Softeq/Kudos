import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class AchievementsViewModel extends BaseViewModel {
  final AchievementsService _achievementsService = locator<AchievementsService>();
  final List<Achievement> achievements = [];

  AchievementsViewModelState _achievementsViewModelState =
      AchievementsViewModelState.busy;

  AchievementsViewModelState get state => _achievementsViewModelState;

  Future<void> initialize() async {
    var result = await _achievementsService.getAchievements();
    achievements.addAll(result);
    _achievementsViewModelState = AchievementsViewModelState.idle;
    notifyListeners();
  }
}

enum AchievementsViewModelState {
  busy,
  idle,
}
