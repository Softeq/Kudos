import 'package:flutter/foundation.dart';
import 'package:kudosapp/dto/achievement.dart';
import 'package:kudosapp/dto/user.dart';

class AchievementToSend {
  final User sender;
  final User recipient;
  final Achievement achievement;
  final String comment;

  AchievementToSend({
    @required this.sender,
    @required this.recipient,
    @required this.achievement,
    @required this.comment,
  });
}