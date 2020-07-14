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
  final List<TeamMember> teamOwners;
  final List<TeamMember> teamMembers;
  final bool isActive;

  Team._({
    this.id,
    this.name,
    this.imageUrl,
    this.imageName,
    this.description,
    this.teamOwners,
    this.teamMembers,
    this.isActive,
  });

  factory Team.fromModel(
    TeamModel model, {
    bool isActive,
    List<UserModel> newMembers,
    List<UserModel> newOwners,
  }) {
    return Team._(
      id: model.id,
      name: model.name,
      imageUrl: model.imageUrl,
      imageName: model.imageName,
      description: model.description,
      teamMembers: (newMembers ?? model.members)
          ?.map((um) => TeamMember.fromModel(um))
          ?.toList(),
      teamOwners: (newOwners ?? model.owners)
          ?.map((um) => TeamMember.fromModel(um))
          ?.toList(),
      isActive: isActive ?? true,
    );
  }

  factory Team.fromJson(
    Map<String, dynamic> map,
    String id,
  ) {
    return map == null
        ? null
        : Team._(
            id: id ?? map["id"],
            name: map["name"],
            imageUrl: map["image_url"],
            imageName: map["image_name"],
            description: map["description"],
            teamOwners: getMembers(map["team_owners"]),
            teamMembers: getMembers(map["team_members"]),
            isActive: map["is_active"],
          );
  }

  Map<String, dynamic> toJson({
    @required bool all,
    bool metadata = false,
    bool image = false,
    bool members = false,
    bool owners = false,
    bool isActive = false,
  }) {
    final map = new Map<String, Object>();

    if (all || metadata) {
      map["name"] = this.name;
      map["description"] = this.description;
    }

    if (all || image) {
      map["image_url"] = this.imageUrl;
      map["image_name"] = this.imageName;
    }

    var visibleFor = List<String>();

    if (all || members) {
      map["team_members"] =
          this.teamMembers?.map((tm) => tm.toJson())?.toList();
      visibleFor.addAll(this.teamMembers?.map((x) => x.id));
    }

    if (all || owners) {
      map["team_owners"] = this.teamOwners?.map((to) => to.toJson())?.toList();
      visibleFor.addAll(this.teamOwners?.map((x) => x.id));
    }

    if (visibleFor.isNotEmpty) {
      visibleFor = visibleFor.toSet().toList();
      map["visible_for"] = visibleFor;
    }

    if (all || isActive) {
      map.putIfAbsent("is_active", () => this.isActive);
    }

    return map;
  }

  static List<TeamMember> getMembers(List<dynamic> members) {
    if (members == null) {
      return List<TeamMember>();
    }

    var mapList = members.cast<Map<String, dynamic>>();
    return mapList.map((y) => TeamMember.fromJson(y, null)).toList();
  }

  @override
  List<Object> get props => [id];
}
