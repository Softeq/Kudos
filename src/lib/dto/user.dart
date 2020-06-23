import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Users collection
@immutable
class User {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final int receivedAchievementsCount;

  User._({
    @required this.id,
    @required this.name,
    this.email,
    @required this.imageUrl,
    @required this.receivedAchievementsCount,
  });

  factory User.fromDocument(DocumentSnapshot x) {
    return User._(
      id: x.documentID,
      name: x.data["name"],
      email: x.data["email"],
      imageUrl: x.data["image_url"],
      receivedAchievementsCount: x.data["received_achievements_count"],
    );
  }

  factory User.fromFirebase(FirebaseUser x) {
    final uid = x.email.split("@").first;

    return User._(
      id: uid,
      name: x.displayName,
      email: x.email,
      imageUrl: x.photoUrl,
      receivedAchievementsCount: 0,
    );
  }

  factory User.mock({int index = 0}) {
    return User._(
      id: "test_id #{$index}",
      name: "Test Name #$index",
      email: "test.name@softeq.com",
      imageUrl: "https://picsum.photos/200?random=$index",
      receivedAchievementsCount: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "image_url": imageUrl,
      "received_achievements_count": receivedAchievementsCount,
    };
  }
}
