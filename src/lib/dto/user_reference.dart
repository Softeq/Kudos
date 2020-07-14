import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/models/user_model.dart';

/// Sender / Recipient [User] model
/// Achievements collection -> user field
@immutable
class UserReference extends Equatable {
  final String id;
  final String name;
  final String imageUrl;

  UserReference._({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
  });

  factory UserReference.fromModel(UserModel model) {
    return UserReference._(
      id: model.id,
      name: model.name,
      imageUrl: model.imageUrl,
    );
  }

  factory UserReference.fromJson(Map<String, dynamic> map, String id) {
    return map == null
        ? null
        : UserReference._(
            id: id ?? map["id"],
            name: map["name"],
            imageUrl: map["image_url"],
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
