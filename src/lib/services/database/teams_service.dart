import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/database/achievements_service.dart';
import 'package:kudosapp/services/image_service.dart';

class TeamsService {
  static const _teamsCollection = "teams";

  final _database = Firestore.instance;
  final _imageService = locator<ImageService>();
  final _authService = locator<BaseAuthService>();
  final _achievementsService = locator<AchievementsService>();

  Future<TeamModel> createTeam(TeamModel team) async {
    if (team.name == null || team.name.isEmpty) {
      throw ArgumentError.notNull(team.name);
    }

    if (team.imageFile != null) {
      var imageData = await _imageService.uploadImage(team.imageFile);
      team.imageUrl = imageData.url;
      team.imageName = imageData.name;
    }

    team.members = [_authService.currentUser];
    team.owners = [_authService.currentUser];

    var map = Team.createMap(
      name: team.name,
      imageUrl: team.imageUrl,
      imageName: team.imageName,
      description: team.description,
      members: team.members,
      owners: team.owners,
      isActive: true,
    );

    var docRef = await _database.collection(_teamsCollection).add(map);

    var document = await docRef.get();
    return TeamModel.fromTeam(Team.fromDocument(document));
  }

  Future<TeamModel> editTeam(TeamModel team) async {
    if (team.name == null || team.name.isEmpty) {
      throw ArgumentError.notNull(team.name);
    }

    final docRef = _database.collection(_teamsCollection).document(team.id);

    if (team.imageFile != null) {
      var imageData = await _imageService.uploadImage(team.imageFile);
      team.imageUrl = imageData.url;
      team.imageName = imageData.name;
    } else {
      team.imageUrl = null;
      team.imageName = null;
    }
    var map = Team.createMap(
      name: team.name,
      description: team.description,
      imageUrl: team.imageUrl,
      imageName: team.imageName,
    );

    await docRef.setData(map, merge: true);

    final document = await docRef.get();
    return TeamModel.fromTeam(Team.fromDocument(document));
  }

  Future<void> updateTeamMembers({
    @required String teamId,
    @required List<UserModel> newMembers,
    @required List<UserModel> newAdmins,
  }) {
    return _database.collection(_teamsCollection).document(teamId).setData(
          Team.createMap(
            members: newMembers,
            owners: newAdmins,
          ),
          merge: true,
        );
  }

  Future<List<TeamModel>> getTeams([String id]) async {
    var userId = id;
    if (userId == null) {
      userId = _authService.currentUser.id;
    }

    final qs = await _database
        .collection(_teamsCollection)
        .where("visible_for", arrayContains: userId)
        .where("is_active", isEqualTo: true)
        .getDocuments();
    return qs.documents
        .map((x) => TeamModel.fromTeam(Team.fromDocument(x)))
        .toList();
  }

  Future<TeamModel> getTeam(String id) async {
    final document =
        await _database.collection(_teamsCollection).document(id).get();
    return TeamModel.fromTeam(Team.fromDocument(document));
  }

  Future<void> deleteTeam(
      TeamModel team, List<AchievementModel> achievements) async {
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

  bool canBeModifiedByCurrentUser(TeamModel team) {
    final userId = _authService.currentUser.id;
    final admin =
        team.owners.firstWhere((x) => x.id == userId, orElse: () => null);
    final result = admin != null;
    return result;
  }
}
