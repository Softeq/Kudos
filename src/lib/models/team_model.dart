import 'dart:core';
import 'dart:io';

import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/dto/team_reference.dart';
import 'package:kudosapp/models/user_model.dart';

class TeamModel {
  String id;
  String name;
  String description;
  String imageUrl;
  String imageName;
  File imageFile;
  List<UserModel> owners;
  List<UserModel> members;

  TeamModel.fromTeam(Team team) {
    _updateWithTeam(team);
  }

  TeamModel.fromTeamReference(TeamReference teamReference) {
    id = teamReference.id;
    name = teamReference.name;
  }

  TeamModel({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.imageName,
  });

  void _updateWithTeam(Team team) {
    id = team.id;
    name = team.name;
    description = team.description;
    imageUrl = team.imageUrl;
    imageName = team.imageName;
    members = team.members.map((tm) => UserModel.fromTeamMember(tm));
    owners = team.owners.map((tm) => UserModel.fromTeamMember(tm));
  }

  void updateWithModel(TeamModel team) {
    id = team.id;
    name = team.name;
    description = team.description;
    imageUrl = team.imageUrl;
    imageName = team.imageName;
    imageFile = team.imageFile;
    members = team.members;
    owners = team.owners;
  }
}
