import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/user_achievement_collection.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class ReceivedAchievementViewModel extends BaseViewModel {
  final UserAchievementCollection achievementCollection;

  AchievementModel get relatedAchievement =>
      achievementCollection.userAchievements[0].achievement;

  ReceivedAchievementViewModel(this.achievementCollection);
}
