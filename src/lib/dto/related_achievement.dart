import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/dto/achievement.dart';
import 'package:kudosapp/models/achievement_model.dart';

/// User [Achievement] model
/// Users collection -> achievement_references subcollection -> achievement field
@immutable
class RelatedAchievement extends Equatable {
  final String id;
  final String name;
  final String imageUrl;

  RelatedAchievement._({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
  });

  factory RelatedAchievement.fromModel(AchievementModel model) {
    return RelatedAchievement._(
      id: model.id,
      name: model.name,
      imageUrl: model.imageUrl,
    );
  }

  factory RelatedAchievement.fromJson(Map<String, dynamic> json, String id) {
    return json == null
        ? null
        : RelatedAchievement._(
            id: id ?? json["id"],
            name: json["name"],
            imageUrl: json["image_url"],
          );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image_url": imageUrl,
    };
  }

  @override
  List<Object> get props => [id];
}
