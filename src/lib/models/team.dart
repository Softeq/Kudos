import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    return {
      "name": name,
      "description": description,
    };
  }
}
