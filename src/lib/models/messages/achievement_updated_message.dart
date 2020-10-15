import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement_model.dart';

@immutable
class AchievementUpdatedMessage {
  final AchievementModel achievement;

  AchievementUpdatedMessage(this.achievement);
}
