import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/team_member.dart';

@immutable
class Team {
  final String id;
  final String name;
  final String description;
  final List<TeamMember> owners;
  final List<TeamMember> members;

  factory Team.fromDocument(
    DocumentSnapshot x,
    List<TeamMember> owners,
    List<TeamMember> members,
  ) {
    return Team._(
      id: x.documentID,
      name: x.data["name"],
      description: x.data["description"],
      owners: owners,
      members: members,
    );
  }

  Team._({
    this.id,
    this.name,
    this.description,
    this.owners,
    this.members,
  });

  Team copy({
    String name,
    String description,
    List<TeamMember> owners,
    List<TeamMember> members,
  }) {
    return Team._(
      id: this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      owners: owners ?? this.owners.toList(),
      members: members ?? this.members.toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return createMap(name: name, description: description);
  }

  static Map<String, dynamic> createMap({
    @required String name,
    @required String description,
    List<String> members,
    List<String> owners,
  }) {
    var map = Map<String, dynamic>();
    map["name"] = name;
    map["description"] = description;

    if (members != null) {
      map["members"] = members;
    }

    if (owners != null) {
      map["owners"] = owners;
    }

    return map;
  }
}
