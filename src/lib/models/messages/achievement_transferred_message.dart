import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement_model.dart';

@immutable
class AchievementTransferredMessage {
  final Set<AchievementModel> achievements;

  AchievementTransferredMessage.multiple(this.achievements);

  AchievementTransferredMessage.single(AchievementModel achievement)
      : achievements = {achievement};
}
