import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String imageUrl;

  User._({
    @required this.id,
    @required this.name,
    this.email,
    @required this.imageUrl,
  });

  factory User.fromDocument(DocumentSnapshot x) {
    return User._(
      id: x.documentID,
      name: x.data["name"],
      email: x.data["email"],
      imageUrl: x.data["imageUrl"],
    );
  }

  factory User.fromFirebase(FirebaseUser x) {
    final uid = x.email.split("@").first;

    return User._(
      id: uid,
      name: x.displayName,
      email: x.email,
      imageUrl: x.photoUrl,
    );
  }

  factory User.mock({int index = 0}) {
    return User._(
      id: "test_id #{$index}",
      name: "Test Name #$index",
      email: "test.name@softeq.com",
      imageUrl: "https://picsum.photos/200?random=$index",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "imageUrl": imageUrl,
    };
  }
}
