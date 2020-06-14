import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/dto/achievement.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/dto/team_member.dart';
import 'package:kudosapp/models/image_data.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/image_service.dart';

import 'achievements_service.dart';

class TeamsService {
  static const String _teamsCollection = "teams";

  final _database = Firestore.instance;
  final _authService = locator<BaseAuthService>();
  final _achievementsService = locator<AchievementsService>();

  Future<Team> createTeam(String name, String description, [File file]) async {
    if (name == null || name.isEmpty) {
      throw ArgumentError.notNull(name);
    }

    ImageData imageData;

    if (file != null) {
      final imageService = locator<ImageService>();
      imageData = await imageService.uploadImage(file);
    }

    var firstMember = TeamMember.fromUser(_authService.currentUser);

    var docRef = await _database.collection(_teamsCollection).add(
          Team.createMap(
            name: name,
            imageUrl: imageData?.url,
            imageName: imageData?.name,
            description: description,
            members: [firstMember],
            owners: [firstMember],
            isActive: true,
          ),
        );

    var document = await docRef.get();
    return Team.fromDocument(document);
  }

  Future<Team> editTeam(String id, String name, String description,
      [File file]) async {
    if (name == null || name.isEmpty) {
      throw ArgumentError.notNull(name);
    }

    final docRef = _database.collection(_teamsCollection).document(id);
    Map<String, dynamic> map;

    if (file != null) {
      final imageService = locator<ImageService>();
      final imageData = await imageService.uploadImage(file);
      map = Team.createMap(
        name: name,
        description: description,
        imageUrl: imageData?.url,
        imageName: imageData?.name,
      );
    } else {
      map = Team.createMap(
        name: name,
        description: description,
      );
    }

    await docRef.setData(map, merge: true);

    final document = await docRef.get();
    return Team.fromDocument(document);
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

    final qs = await _database
        .collection(_teamsCollection)
        .where("visible_for", arrayContains: userId)
        .where("is_active", isEqualTo: true)
        .getDocuments();
    return qs.documents.map((x) => Team.fromDocument(x)).toList();
  }

  Future<Team> getTeam(String id) async {
    final document =
        await _database.collection(_teamsCollection).document(id).get();
    return Team.fromDocument(document);
  }

  Future<void> deleteTeam(Team team, List<Achievement> achievements) async {
    final docRef = _database.collection(_teamsCollection).document(team.id);

    var batch = _database.batch();

    if (achievements != null && achievements.length > 0) {
      for (var achievement in achievements) {
        _achievementsService.deleteAchievement(achievement.id, batch: batch);
      }
    }

    var map = Team.createMap(isActive: false);
    batch.setData(docRef, map, merge: true);
    await batch.commit();
  }

  bool canBeModifiedByCurrentUser(Team team) {
    final userId = _authService.currentUser.id;
    final admin =
        team.owners.firstWhere((x) => x.id == userId, orElse: () => null);
    final result = admin != null;
    return result;
  }
}
