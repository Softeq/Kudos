import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/user_model.dart';

/// Users collection
@immutable
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final int receivedAchievementsCount;

  User._({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.imageUrl,
    @required this.receivedAchievementsCount,
  });

  factory User.fromJson(Map<String, dynamic> json, String id) {
    return json == null
        ? null
        : User._(
            id: id ?? json["id"],
            name: json["name"],
            email: json["email"],
            imageUrl: json["image_url"],
            receivedAchievementsCount: json["received_achievements_count"],
          );
  }

  factory User.fromModel(UserModel model) {
    return User._(
      id: model.id,
      name: model.name,
      email: model.email,
      imageUrl: model.imageUrl,
      receivedAchievementsCount: model.receivedAchievementsCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "image_url": imageUrl,
      "received_achievements_count": receivedAchievementsCount,
    };
  }

  @override
  List<Object> get props => [id];
}
