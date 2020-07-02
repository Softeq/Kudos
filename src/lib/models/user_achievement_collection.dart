import 'package:kudosapp/dto/user_achievement.dart';

class UserAchievementCollection {
  final List<UserAchievement> userAchievements;
  final String imageUrl;

  int get count => userAchievements.length;

  UserAchievementCollection._(this.userAchievements, this.imageUrl);

  factory UserAchievementCollection.single(UserAchievement userAchievement) {
    final userAchievements = new List<UserAchievement>();
    userAchievements.add(userAchievement);
    return UserAchievementCollection._(userAchievements, userAchievement.achievement.imageUrl);
  }

  UserAchievementCollection addAchievement(UserAchievement userAchievement) {
    userAchievements.add(userAchievement);
    userAchievements.sort((x, y) => y.date.compareTo(x.date));
    return UserAchievementCollection._(userAchievements, imageUrl);
  }

  String get senders {
    return userAchievements
        .map((x) => x.sender.name)
        .toSet()
        .toList()
        .join(", ");
  }
}
