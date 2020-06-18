import 'package:flutter/material.dart';
import 'package:kudosapp/dto/achievement.dart';

@immutable
class AchievementTransferredMessage {
  final Set<Achievement> achievements;

  AchievementTransferredMessage.multiple(this.achievements);

  AchievementTransferredMessage.single(Achievement achievement)
      : achievements = {achievement};
}
