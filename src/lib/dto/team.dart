import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/dto/team_member.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_model.dart';

/// Teams collection
@immutable
class Team extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String imageName;
  final String description;
  final List<TeamMember> owners;
  final List<TeamMember> members;
  final bool isActive;

  Team._({
    this.id,
    this.name,
    this.imageUrl,
    this.imageName,
    this.description,
    this.owners,
    this.members,
    this.isActive,
  });

  factory Team.fromModel(TeamModel model,
      {bool isActive, List<UserModel> newMembers, List<UserModel> newOwners}) {
    return Team._(
      id: model.id,
      name: model.name,
      imageUrl: model.imageUrl,
      imageName: model.imageName,
      description: model.description,
      members:
          (newMembers ?? model.members)?.map((um) => TeamMember.fromModel(um)),
      owners:
          (newOwners ?? model.owners)?.map((um) => TeamMember.fromModel(um)),
      isActive: isActive ?? true,
    );
  }

  factory Team.fromDocument(DocumentSnapshot x) {
    return Team._(
      id: x.documentID,
      name: x.data["name"],
      imageUrl: x.data["image_url"],
      imageName: x.data["image_name"],
      description: x.data["description"],
      owners: getMembers(x.data["team_owners"]),
      members: getMembers(x.data["team_members"]),
      isActive: x.data["is_active"],
    );
  }

  Map<String, dynamic> toMap({
    @required bool all,
    bool metadata,
    bool image,
    bool members,
    bool owners,
    bool isActive,
  }) {
    final map = new Map<String, Object>();

    if (metadata) {
      map["name"] = this.name;
      map["description"] = this.description;
    }

    if (image) {
      map["image_url"] = this.imageUrl;
      map["image_name"] = this.imageName;
    }

    var visibleFor = List<String>();

    if (members) {
      map["team_members"] = this.members;
      visibleFor.addAll(this.members.map((x) => x.id));
    }

    if (owners) {
      map["team_owners"] = this.owners;
      visibleFor.addAll(this.owners.map((x) => x.id));
    }

    if (visibleFor.isNotEmpty) {
      visibleFor = visibleFor.toSet().toList();
      map["visible_for"] = visibleFor;
    }

    if (isActive) {
      map.putIfAbsent("is_active", () => this.isActive);
    }

    return map;
  }

  static List<TeamMember> getMembers(List<dynamic> x) {
    if (x == null) {
      return List<TeamMember>();
    }

    var mapList = x.cast<Map<String, dynamic>>();
    return mapList.map((y) => TeamMember.fromMap(y)).toList();
  }

  @override
  List<Object> get props => [id];
}
