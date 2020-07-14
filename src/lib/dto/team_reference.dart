import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/team_model.dart';

/// Achievements collection -> team field
@immutable
class TeamReference extends Equatable {
  final String id;
  final String name;

  TeamReference._({
    @required this.id,
    @required this.name,
  });

  factory TeamReference.fromJson(Map<String, dynamic> map, String id) {
    return map == null
        ? null
        : TeamReference._(
            id: id ?? map["id"],
            name: map["name"],
          );
  }

  factory TeamReference.fromModel(TeamModel model) {
    return TeamReference._(
      id: model.id,
      name: model.name,
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
