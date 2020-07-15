import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/user_model.dart';

/// Teams collection -> team_members array
@immutable
class TeamMember extends Equatable {
  final String id;
  final String name;

  TeamMember._(
    this.id,
    this.name,
  );

  factory TeamMember.fromModel(UserModel model) {
    return TeamMember._(
      model.id,
      model.name,
    );
  }

  factory TeamMember.fromJson(Map<String, dynamic> json, String id) {
    return json == null
        ? null
        : TeamMember._(
            id ?? json["id"],
            json["name"],
          );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }

  @override
  List<Object> get props => [id];
}
