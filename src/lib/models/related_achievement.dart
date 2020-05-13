import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/achievement.dart';

/// User [Achievement] model
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
      imageUrl: x["imageUrl"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "imageUrl": imageUrl,
    };
  }
}
