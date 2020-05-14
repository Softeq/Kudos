import 'package:kudosapp/models/user_achievement.dart';

class UserAchievementCollection {
  final UserAchievement userAchievement;
  final int count;

  const UserAchievementCollection._(this.userAchievement, this.count);

  factory UserAchievementCollection.single(UserAchievement userAchievement) {
    return UserAchievementCollection._(userAchievement, 1);
  }

  UserAchievementCollection increaseCount() {
    return UserAchievementCollection._(userAchievement, count + 1);
  }
}
