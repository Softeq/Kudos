import 'package:flutter/foundation.dart';
import 'package:kudosapp/dto/user.dart';

/// Sender / Recipient [User] model
/// Achievements collection -> user field
@immutable
class UserReference {
  final String id;
  final String name;
  final String imageUrl;

  UserReference._({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
  });

  factory UserReference.fromUser(User x) {
    return UserReference._(
      id: x.id,
      name: x.name,
      imageUrl: x.imageUrl,
    );
  }

  factory UserReference.fromMap(Map<String, dynamic> x) {
    if (x == null) {
      return null;
    }

    return UserReference._(
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
