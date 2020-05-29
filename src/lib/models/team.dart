import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/team_member.dart';

@immutable
class Team {
  final String id;
  final String name;
  final String imageUrl;
  final String imageName;
  final String description;
  final List<TeamMember> owners;
  final List<TeamMember> members;

  factory Team.fromDocument(DocumentSnapshot x) {
    return Team._(
      id: x.documentID,
      name: x.data["name"],
      imageUrl: x.data["image_url"],
      imageName: x.data["image_name"],
      description: x.data["description"],
      owners: getMembers(x.data["team_owners"]),
      members: getMembers(x.data["team_members"]),
    );
  }

  Team._({
    this.id,
    this.name,
    this.imageUrl,
    this.imageName,
    this.description,
    this.owners,
    this.members,
  });

  Team copy({
    String name,
    String imageUrl,
    String imageName,
    String description,
    List<TeamMember> owners,
    List<TeamMember> members,
  }) {
    return Team._(
      id: this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      imageName: imageName ?? this.imageName,
      description: description ?? this.description,
      owners: owners ?? this.owners.toList(),
      members: members ?? this.members.toList(),
    );
  }

  static List<TeamMember> getMembers(List<dynamic> x) {
    if (x == null) {
      return List<TeamMember>();
    }

    var mapList = x.cast<Map<String, dynamic>>();
    return mapList.map((y) => TeamMember.fromMap(y)).toList();
  }

  static Map<String, dynamic> createMap({
    String name,
    String imageUrl,
    String imageName,
    String description,
    List<TeamMember> members,
    List<TeamMember> owners,
  }) {
    var map = Map<String, dynamic>();

    if (name != null) {
      map["name"] = name;
    }

    if (imageUrl != null) {
      map["image_url"] = imageUrl;
    }

    if (imageName != null) {
      map["image_name"] = imageName;
    }

    if (description != null) {
      map["description"] = description;
    }

    var visibleFor = List<String>();

    if (members != null) {
      map["team_members"] = members.map((x) => x.toMap()).toList();
      visibleFor.addAll(members.map((x) => x.id));
    }

    if (owners != null) {
      map["team_owners"] = owners.map((x) => x.toMap()).toList();
      visibleFor.addAll(owners.map((x) => x.id));
    }

    if (visibleFor.isNotEmpty) {
      visibleFor = visibleFor.toSet().toList();
      map["visible_for"] = visibleFor;
    }

    return map;
  }
}
