import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/helpers/image_uploader.dart';
import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/models/team_member.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';

class TeamsService {
  static const String _teamsCollection = "teams";

  final _database = Firestore.instance;
  final _authService = locator<BaseAuthService>();

  Future<Team> createTeam(String name, String description, [File file]) async {
    if (name == null || name.isEmpty) {
      throw ArgumentError.notNull(name);
    }

    var imageUrl = await ImageUploader.uploadImage(file);

    var firstMember = TeamMember.fromUser(_authService.currentUser);

    var docRef = await _database.collection(_teamsCollection).add(
          Team.createMap(
            name: name,
            imageUrl: imageUrl,
            description: description,
            members: [firstMember],
            owners: [firstMember],
          ),
        );

    var document = await docRef.get();
    return Team.fromDocument(document);
  }

  Future<void> editTeam(String id, String name, String description,
      [File file]) async {
    if (name == null || name.isEmpty) {
      throw ArgumentError.notNull(name);
    }

    var imageUrl = await ImageUploader.uploadImage(file);

    await _database.collection(_teamsCollection).document(id).setData(
        Team.createMap(
            name: name, description: description, imageUrl: imageUrl),
        merge: true);
  }

  Future<void> updateTeamMembers({
    @required String teamId,
    @required List<TeamMember> newMembers,
    @required List<TeamMember> newAdmins,
  }) {
    return _database.collection(_teamsCollection).document(teamId).setData(
          Team.createMap(
            members: newMembers,
            owners: newAdmins,
          ),
          merge: true,
        );
  }

  Future<List<Team>> getTeams([String id]) async {
    var userId = id;
    if (userId == null) {
      userId = _authService.currentUser.id;
    }

    var qs = await _database
        .collection(_teamsCollection)
        .where("visible_for", arrayContains: userId)
        .getDocuments();
    return qs.documents.map((x) => Team.fromDocument(x)).toList();
  }

  Future<Team> getTeam(String id) async {
    var document =
        await _database.collection(_teamsCollection).document(id).get();
    return Team.fromDocument(document);
  }
}
