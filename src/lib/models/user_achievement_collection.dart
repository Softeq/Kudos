import 'package:kudosapp/models/user_achievement.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';

class UserAchievementCollection {
  final List<UserAchievement> userAchievements;
  final ImageViewModel imageViewModel;

  int get count => userAchievements.length;

  UserAchievementCollection._(this.userAchievements, this.imageViewModel);

  factory UserAchievementCollection.single(UserAchievement userAchievement) {
    final imageViewModel = ImageViewModel();
    imageViewModel.initialize(userAchievement.achievement.imageUrl, null, false);
    var userAchievements = new List<UserAchievement>();
    userAchievements.add(userAchievement);
    return UserAchievementCollection._(userAchievements, imageViewModel);
  }

  UserAchievementCollection addAchievement(UserAchievement userAchievement) {
    userAchievements.add(userAchievement);
    userAchievements.sort((x, y) => y.date.compareTo(x.date));
    return UserAchievementCollection._(userAchievements, imageViewModel);
  }
}
