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
    Map<String, dynamic> json,
    String id,
  ) {
    return json == null
        ? null
        : Team._(
            id: id ?? json["id"],
            name: json["name"],
            imageUrl: json["image_url"],
            imageName: json["image_name"],
            description: json["description"],
            teamOwners: getMembers(json["team_owners"]),
            teamMembers: getMembers(json["team_members"]),
            isActive: json["is_active"],
          );
  }

  Map<String, dynamic> toJson({
    bool addAll = false,
    bool addMetadata = false,
    bool addImage = false,
    bool addMembers = false,
    bool addOwners = false,
    bool addIsActive = false,
  }) {
    final map = new Map<String, Object>();

    if (addAll || addMetadata) {
      map["name"] = this.name;
      map["description"] = this.description;
    }

    if (addAll || addImage) {
      map["image_url"] = this.imageUrl;
      map["image_name"] = this.imageName;
    }

    var visibleFor = List<String>();

    if (addAll || addMembers) {
      map["team_members"] =
          this.teamMembers?.map((tm) => tm.toJson())?.toList();
      visibleFor.addAll(this.teamMembers?.map((x) => x.id));
    }

    if (addAll || addOwners) {
      map["team_owners"] = this.teamOwners?.map((to) => to.toJson())?.toList();
      visibleFor.addAll(this.teamOwners?.map((x) => x.id));
    }

    if (visibleFor.isNotEmpty) {
      visibleFor = visibleFor.toSet().toList();
      map["visible_for"] = visibleFor;
    }

    if (addAll || addIsActive) {
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
