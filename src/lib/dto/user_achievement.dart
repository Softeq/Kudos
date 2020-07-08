import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory UserAchievement.fromDocument(DocumentSnapshot x) {
    return UserAchievement._(
      sender: UserReference.fromMap(x.data["sender"]),
      achievement: RelatedAchievement.fromMap(x.data["achievement"]),
      comment: x.data["comment"],
      date: x.data["date"].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "sender": sender.toMap(),
      "achievement": achievement.toMap(),
      "comment": comment,
      "date": date,
    };
  }
}
