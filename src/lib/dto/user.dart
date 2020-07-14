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

  factory User.fromJson(Map<String, dynamic> map, String id) {
    return map == null
        ? null
        : User._(
            id: id ?? map["id"],
            name: map["name"],
            email: map["email"],
            imageUrl: map["image_url"],
            receivedAchievementsCount: map["received_achievements_count"],
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
