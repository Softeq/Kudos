import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Users collection
@immutable
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final int receivedAchievementsCount;
  final List<String> achievementsOrdering;

  User._({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.imageUrl,
    @required this.receivedAchievementsCount,
    @required this.achievementsOrdering,
  });

  factory User.fromJson(Map<String, dynamic> json, String id) {
    List<String> getOrdering(List<dynamic> items) {
      if (items == null) {
        return null;
      }

      return items.map((x) => x as String).toList();
    }

    return json == null
        ? null
        : User._(
            id: id ?? json["id"],
            name: json["name"],
            email: json["email"],
            imageUrl: json["image_url"],
            receivedAchievementsCount: json["received_achievements_count"],
            achievementsOrdering: getOrdering(json["achievements_ordering"]),
          );
  }

  @override
  List<Object> get props => [id];
}
