
import 'package:flutter/material.dart';
@immutable
class AchievementDeletedMessage {
  final Set<String> ids;

  AchievementDeletedMessage.multiple(this.ids);
  AchievementDeletedMessage.single(String achievementId) : ids = {achievementId};
}