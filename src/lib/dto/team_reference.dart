import 'package:flutter/foundation.dart';

/// Achievements collection -> team field
@immutable
class TeamReference {
  final String id;
  final String name;

  factory TeamReference.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return TeamReference(
      id: map["id"],
      name: map["name"],
    );
  }

  TeamReference({
    @required this.id,
    @required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }
}
