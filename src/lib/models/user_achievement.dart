import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/user.dart';

class UserAchievement {
  final User sender;
  final User recipient;
  final Achievement achievement;
  final String comment;

  UserAchievement({
    @required this.sender,
    @required this.recipient,
    @required this.achievement,
    @required this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": achievement.id,
      "name": achievement.name,
      "imageUrl": achievement.imageUrl,
      "comment": comment,
      "sender_user": sender.toMapForUserAchievement(),
    };
  }
}
