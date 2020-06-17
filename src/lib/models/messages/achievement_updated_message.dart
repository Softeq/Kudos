import 'package:flutter/material.dart';
import 'package:kudosapp/dto/achievement.dart';

@immutable
class AchievementUpdatedMessage {
  final Achievement achievement;

  AchievementUpdatedMessage(this.achievement);
}