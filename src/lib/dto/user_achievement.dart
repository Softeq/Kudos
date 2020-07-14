import 'package:flutter/foundation.dart';
import 'package:kudosapp/dto/related_achievement.dart';
import 'package:kudosapp/dto/user_reference.dart';
import 'package:kudosapp/models/user_achievement_model.dart';

/// Users collection -> achievement_references subcollection
@immutable
class UserAchievement {
  final UserReference sender;
  final RelatedAchievement achievement;
  final String comment;
  final DateTime date;

  UserAchievement._({
    @required this.sender,
    @required this.achievement,
    @required this.comment,
    @required this.date,
  });

  factory UserAchievement.fromModel(UserAchievementModel model) {
    return UserAchievement._(
      sender: UserReference.fromModel(model.sender),
      achievement: RelatedAchievement.fromModel(model.achievement),
      comment: model.comment,
      date: model.date,
    );
  }

  factory UserAchievement.fromJson(Map<String, dynamic> map, String id) {
    return map == null
        ? null
        : UserAchievement._(
            sender: UserReference.fromJson(map["sender"], null),
            achievement: RelatedAchievement.fromJson(map["achievement"], null),
            comment: map["comment"],
            date: map["date"].toDate(),
          );
  }

  Map<String, dynamic> toJson() {
    return {
      "sender": sender.toJson(),
      "achievement": achievement.toJson(),
      "comment": comment,
      "date": date,
    };
  }
}
