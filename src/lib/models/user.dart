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
    @required this.email,
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
    return User._(
      id: x.uid,
      name: x.displayName,
      email: x.email,
      imageUrl: x.photoUrl,
    );
  }

  factory User.mock() {
    return User._(
      id: "test_id",
      name: "Test Name",
      email: "test.name@softeq.com",
      imageUrl: "https://via.placeholder.com/150",
    );
  }

  Map<String, dynamic> toMapForRegistration() {
    return {
      "name": name,
      "email": email,
      "imageUrl": imageUrl,
    };
  }

  Map<String, dynamic> toMapForUserAchievement() {
    return {
      "id": id,
      "name": name,
      "imageUrl": imageUrl,
    };
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
