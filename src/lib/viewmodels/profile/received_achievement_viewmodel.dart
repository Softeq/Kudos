import 'package:kudosapp/dto/related_achievement.dart';
import 'package:kudosapp/models/user_achievement_collection.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class ReceivedAchievementViewModel extends BaseViewModel {
  final UserAchievementCollection achievementCollection;

  RelatedAchievement get relatedAchievement =>
      achievementCollection.userAchievements[0].achievement;

  ReceivedAchievementViewModel(this.achievementCollection);
}
