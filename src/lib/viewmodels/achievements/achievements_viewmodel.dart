import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/database/achievements_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class AchievementsViewModel extends BaseViewModel {
  final achievements = List<AchievementModel>();

  final _achievementsService = locator<AchievementsService>();

  Future<void> initialize() async {
    isBusy = true;

    var result = await _achievementsService.getAchievements();
    achievements.forEach((x) => x.dispose());
    achievements.clear();
    achievements.addAll(result.map((x) => AchievementModel(x)));

    isBusy = false;

    notifyListeners();
  }

  @override
  void dispose() {
    achievements.forEach((x) => x.dispose());
    super.dispose();
  }
}
