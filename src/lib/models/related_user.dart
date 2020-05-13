import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/user.dart';

/// Sender / Recipient [User] model
class RelatedUser {
  final String id;
  final String name;
  final String imageUrl;

  RelatedUser._({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
  });

  factory RelatedUser.fromUser(User x) {
    return RelatedUser._(
      id: x.id,
      name: x.name,
      imageUrl: x.imageUrl,
    );
  }

  factory RelatedUser.fromMap(Map<String, dynamic> x) {
    return RelatedUser._(
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
