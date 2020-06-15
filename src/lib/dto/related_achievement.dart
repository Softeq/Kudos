import 'package:flutter/foundation.dart';
import 'package:kudosapp/dto/achievement.dart';

/// User [Achievement] model
/// Users collection -> achievement_references subcollection -> achievement field
@immutable
class RelatedAchievement {
  final String id;
  final String name;
  final String imageUrl;

  RelatedAchievement({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
  });

  factory RelatedAchievement.fromAchievement(Achievement x) {
    return RelatedAchievement(
      id: x.id,
      name: x.name,
      imageUrl: x.imageUrl,
    );
  }

  factory RelatedAchievement.fromMap(Map<String, dynamic> x) {
    return RelatedAchievement(
      id: x["id"],
      name: x["name"],
      imageUrl: x["image_url"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "image_url": imageUrl,
    };
  }
}
