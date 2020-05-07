import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/achievement_category.dart';

class Achievement {
  final List<String> tags;
  final String name;
  final String imageUrl;
  AchievementCategory category;

  Achievement({
    @required this.imageUrl,
    @required this.tags,
    @required this.name,
  });
}