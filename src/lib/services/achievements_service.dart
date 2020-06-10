import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/achievement_holder.dart';
import 'package:kudosapp/models/achievement_to_send.dart';
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
  final _database = Firestore.instance;
  final _achievementsCollection = "achievements";
  final _achievementReferencesCollection = "achievement_references";
  final _authService = locator<BaseAuthService>();

  Future<List<Achievement>> getAchievements() async {
    final snapshot = await _database
        .collection(_achievementsCollection)
        .where("user", isNull: true)
        .where("is_active", isEqualTo: true)
        .getDocuments();
    final result = snapshot.documents.map((x) {
      return Achievement.fromDocument(x);
    }).toList();
    return result;
  }

  Future<Achievement> createOrUpdate({
    @required Achievement achievement,
    Team team,
    User user,
    File file,
  }) async {
    if ((achievement.id == null && file == null) ||
        achievement.imageUrl == null && file == null) {
      throw ArgumentError.notNull("file");
    }

    if (achievement.name == null || achievement.name == "") {
      throw ArgumentError.notNull("name");
    }

    if (achievement.description == null || achievement.description == "") {
      throw ArgumentError.notNull("description");
    }

    var copyOfAchievement = achievement.copy();

    if (team != null) {
      copyOfAchievement = copyOfAchievement.copy(
        teamReference: TeamReference(
          name: team.name,
          id: team.id,
        ),
      );
    }

    if (user != null) {
      copyOfAchievement = copyOfAchievement.copy(
        userReference: UserReference.fromUser(user),
      );
    }

    if (copyOfAchievement.teamReference == null &&
        copyOfAchievement.userReference == null) {
      throw ArgumentError("team or user should be set");
    }

    if (file != null) {
      final imageService = locator<ImageService>();
      final imageData = await imageService.uploadImage(file);
      copyOfAchievement = copyOfAchievement.copy(
        imageUrl: imageData.url,
        imageName: imageData.name,
      );
    }

    if (copyOfAchievement.id == null) {
      final docRef = await _database
          .collection(_achievementsCollection)
          .add(copyOfAchievement.toMap(team));

      final document = await docRef.get();
      return Achievement.fromDocument(document);
    } else {
      await _database
          .collection(_achievementsCollection)
          .document(copyOfAchievement.id)
          .setData(copyOfAchievement.toMap(team));
    }

    return copyOfAchievement;
  }

  Future<void> deleteAchievement(
      Achievement achievement, int holdersCount) async {
    if (holdersCount == 0) {
      return _database
          .collection(_achievementsCollection)
          .document(achievement.id)
          .delete();
    } else {
      achievement = achievement.copy(isActive: false);
      return createOrUpdate(achievement: achievement);
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
    final achievement = Achievement.fromDocument(documentSnapshot);
    final canBeModifiedByCurrentUser = _canBeModifiedByCurrentUser(
      documentSnapshot,
      achievement,
    );
    var canBeSentByCurrentUser = canBeModifiedByCurrentUser;
    if (!canBeSentByCurrentUser) {
      canBeSentByCurrentUser = _canBeSentByCurrentUser(
        documentSnapshot,
        achievement,
      );
    }

    return achievement.copy(
      canBeModifiedByCurrentUser: canBeModifiedByCurrentUser,
      canBeSentByCurrentUser: canBeSentByCurrentUser,
    );
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
        qs.documents.map((x) => Achievement.fromDocument(x)).toList();
    return result;
  }

  bool _canBeModifiedByCurrentUser(
      DocumentSnapshot snapshot, Achievement achievement) {
    if (!achievement.isActive) {
      return false;
    }
    final userId = _authService.currentUser.id;

    if (_ownedByCurrentUser(achievement, userId)) {
      return true;
    }

    return _contains(snapshot.data["owners"], userId);
  }

  bool _canBeSentByCurrentUser(
      DocumentSnapshot snapshot, Achievement achievement) {
    if (!achievement.isActive) {
      return false;
    }
    final userId = _authService.currentUser.id;

    if (_ownedByCurrentUser(achievement, userId)) {
      return true;
    }

    return _contains(snapshot.data["members"], userId);
  }

  bool _contains(List<dynamic> list, value) {
    if (list == null) {
      return false;
    }

    return List<String>.from(list).contains(value);
  }

  bool _ownedByCurrentUser(Achievement achievement, String userId) {
    return achievement.userReference != null &&
        achievement.userReference.id == userId;
  }
}
