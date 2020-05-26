import 'package:kudosapp/models/user_achievement.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';

class UserAchievementCollection {
  final UserAchievement userAchievement;
  final int count;
  final ImageViewModel imageViewModel;

  UserAchievementCollection._(this.userAchievement, this.count, this.imageViewModel);

  factory UserAchievementCollection.single(UserAchievement userAchievement) {
    final imageViewModel = ImageViewModel();
    imageViewModel.initialize(userAchievement.achievement.imageUrl, null, false);
    return UserAchievementCollection._(userAchievement, 1, imageViewModel);
  }

  UserAchievementCollection increaseCount() {
    return UserAchievementCollection._(userAchievement, count + 1, imageViewModel);
  }
}
