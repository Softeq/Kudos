import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Achievement {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> tags;

  Achievement._({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.imageUrl,
    @required this.tags,
  });

  factory Achievement.fromDocument(DocumentSnapshot x) {
    var tagData = x.data["tag"];
    List<String> tags;
    if (tagData != null) {
      tags = tagData.cast<String>().toList();
    }

    return Achievement._(
      description: x.data["description"],
      tags: tags ?? List<String>(),
      name: x.data["name"],
      imageUrl: x.data["imageUrl"],
      id: x.documentID,
    );
  }

  factory Achievement.empty() {
    return Achievement._(
      description: null,
      tags: null,
      name: null,
      imageUrl: null,
      id: null,
    );
  }

  Achievement copy({
    String name,
    String description,
    String imageUrl,
  }) {
    return Achievement._(
      id: this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "imageUrl": imageUrl,
      "tags": tags,
    };
  }
}
