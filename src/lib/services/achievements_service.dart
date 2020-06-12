import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/achievement_holder.dart';
import 'package:kudosapp/models/achievement_to_send.dart';
import 'package:kudosapp/models/image_data.dart';
import 'package:kudosapp/models/related_achievement.dart';
import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/models/team_reference.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/models/user_achievement.dart';
import 'package:kudosapp/models/user_reference.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/image_service.dart';

class AchievementsService {
  static const String _achievementsCollection = "achievements";
  static const String _achievementReferencesCollection =
      "achievement_references";

  final _database = Firestore.instance;
  final _authService = locator<BaseAuthService>();
  final imageService = locator<ImageService>();

  Future<List<Achievement>> getAchievements() async {
    final snapshot = await _database
        .collection(_achievementsCollection)
        .where("user", isNull: true)
        .where("is_active", isEqualTo: true)
        .getDocuments();
    return snapshot.documents.map((x) => Achievement.fromDocument(x, _authService.currentUser.id)).toList();
  }

  Future<Achievement> createAchievement(
      {@required String name,
      @required String description,
      @required File file,
      User user,
      Team team}) async {
    UserReference userReference;
    TeamReference teamReference;

    if (user != null) {
      userReference = UserReference.fromUser(user);
    } else if (team != null) {
      teamReference = TeamReference(
        name: team.name,
        id: team.id,
      );
    } else {
      throw ArgumentError("Team or user must be set");
    }

    var imageData = await imageService.uploadImage(file);

    final docRef = await _database
        .collection(_achievementsCollection)
        .add(Achievement.createMap(
          name: name,
          description: description,
          isActive: true,
          imageName: imageData?.name,
          imageUrl: imageData?.url,
          userReference: userReference,
          teamReference: teamReference,
          team: team,
        ));

    final document = await docRef.get();
    return Achievement.fromDocument(document, _authService.currentUser.id);
  }

  Future<Achievement> _updateAchievement(
      {@required String id,
      @required Map<String, dynamic> data,
      WriteBatch batch}) async {
    final docRef = _database.collection(_achievementsCollection).document(id);
    if (batch == null) {
      await docRef.setData(data, merge: true);

      final document = await docRef.get();
      return Achievement.fromDocument(document, _authService.currentUser.id);
    } else {
      batch.setData(docRef, data, merge: true);
      return null;
    }
  }

  Future<Achievement> updateAchievement(
      {@required String id,
      String name,
      String description,
      bool isActive,
      File file,
      WriteBatch batch}) async {
    ImageData imageData;

    if (file != null) {
      final imageService = locator<ImageService>();
      imageData = await imageService.uploadImage(file);
    }

    final data = Achievement.createMap(
      imageUrl: imageData?.url,
      imageName: imageData?.name,
      name: name,
      description: description,
      isActive: isActive,
    );

    return _updateAchievement(id: id, data: data, batch: batch);
  }

  Future<Achievement> transferAchievement(
      {@required String id, Team team, User user, WriteBatch batch}) async {
    UserReference userReference;
    TeamReference teamReference;
    if (user != null && team != null)
    {
      throw ArgumentError("Team and user can't be set simultaneously");
    }
    else if (user != null) {
      userReference = UserReference.fromUser(user);
    } else if (team != null) {
      teamReference = TeamReference(
        name: team.name,
        id: team.id,
      );
    } else {
      throw ArgumentError("Team or user must be set");
    }

    final data = Achievement.createMap(
      userReference: userReference,
      teamReference: teamReference,
    );
    return _updateAchievement(id: id, data: data, batch: batch);
  }

  Future<void> deleteAchievement(String id,
      {int holdersCount, WriteBatch batch}) {
    if (holdersCount != null && holdersCount == 0) {
      return _database
          .collection(_achievementsCollection)
          .document(id)
          .delete();
    } else {
      final data = Achievement.createMap(
        isActive: false,
      );
      return _updateAchievement(id: id, data: data, batch: batch);
    }
  }

  Future<void> sendAchievement(AchievementToSend sendAchievement) async {
    final timestamp = Timestamp.now();

    final batch = _database.batch();

    // add an achievement to user's achievements

    final userAchievementsReference = _database.collection(
        "users/${sendAchievement.recipient.id}/$_achievementReferencesCollection");

    final userAchievementMap = UserAchievement(
      sender: UserReference.fromUser(sendAchievement.sender),
      achievement:
          RelatedAchievement.fromAchievement(sendAchievement.achievement),
      comment: sendAchievement.comment,
      date: timestamp,
    ).toMap();

    batch.setData(userAchievementsReference.document(), userAchievementMap);

    // add a user to achievements

    final achievementHoldersReference = _database.collection(
        "$_achievementsCollection/${sendAchievement.achievement.id}/holders");

    final holderMap = AchievementHolder(
      date: timestamp,
      recipient: UserReference.fromUser(sendAchievement.recipient),
    ).toMap();

    batch.setData(achievementHoldersReference.document(), holderMap);

    await batch.commit();
  }

  Future<List<UserAchievement>> getUserAchievements(String userId) async {
    final queryResult = await _database
        .collection("users/$userId/$_achievementReferencesCollection")
        .getDocuments();
    final userAchievements = queryResult.documents
        .map((x) => UserAchievement.fromDocument(x))
        .toList();
    return userAchievements;
  }

  Future<List<AchievementHolder>> getAchievementHolders(
      String achivementId) async {
    final queryResult = await _database
        .collection("$_achievementsCollection/$achivementId/holders")
        .getDocuments();
    final achievementHolders = queryResult.documents
        .map((x) => AchievementHolder.fromDocument(x))
        .toSet()
        .toList();
    return achievementHolders;
  }

  Future<Achievement> getAchievement(String achivementId) async {
    final documentSnapshot = await _database
        .collection(_achievementsCollection)
        .document(achivementId)
        .get();
    return Achievement.fromDocument(documentSnapshot, _authService.currentUser.id);
  }

  Future<List<Achievement>> getTeamAchievements(String teamId) {
    return _getAchievements("team.id", teamId);
  }

  Future<List<Achievement>> getMyAchievements() {
    final userId = _authService.currentUser.id;
    return _getAchievements("user.id", userId);
  }

  Future<List<Achievement>> _getAchievements(String field, String value) async {
    final qs = await _database
        .collection(_achievementsCollection)
        .where(field, isEqualTo: value)
        .where("is_active", isEqualTo: true)
        .getDocuments();
    final result =
        qs.documents.map((x) => Achievement.fromDocument(x, _authService.currentUser.id)).toList();
    return result;
  }
}
