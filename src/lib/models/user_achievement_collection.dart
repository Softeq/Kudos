import 'package:kudosapp/dto/user_achievement.dart';

class UserAchievementCollection {
  final List<UserAchievement> userAchievements;
  final String imageUrl;
  final String name;

  int get count => userAchievements.length;

  UserAchievementCollection._(this.userAchievements, this.name, this.imageUrl);

  factory UserAchievementCollection.single(UserAchievement userAchievement) {
    final userAchievements = new List<UserAchievement>();
    userAchievements.add(userAchievement);
    return UserAchievementCollection._(userAchievements,
        userAchievement.achievement.name, userAchievement.achievement.imageUrl);
  }

  UserAchievementCollection addAchievement(UserAchievement userAchievement) {
    userAchievements.add(userAchievement);
    userAchievements.sort((x, y) => y.date.compareTo(x.date));
    return UserAchievementCollection._(userAchievements, name, imageUrl);
  }

  String get senders {
    return userAchievements
        .map((x) => x.sender.name)
        .toSet()
        .toList()
        .join(", ");
  }
}
