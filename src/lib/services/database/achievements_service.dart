import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/dto/achievement.dart';
import 'package:kudosapp/dto/achievement_holder.dart';
import 'package:kudosapp/dto/related_achievement.dart';
import 'package:kudosapp/dto/team_reference.dart';
import 'package:kudosapp/dto/user_achievement.dart';
import 'package:kudosapp/dto/user_reference.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/image_data.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_achievement_model.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/image_service.dart';

class AchievementsService {
  static const _achievementsCollection = "achievements";
  static const _achievementReferencesCollection = "achievement_references";

  final _database = Firestore.instance;
  final _imageService = locator<ImageService>();
  final _authService = locator<BaseAuthService>();

  Future<List<AchievementModel>> getAchievements() async {
    final snapshot = await _database
        .collection(_achievementsCollection)
        .where("user", isNull: true)
        .where("is_active", isEqualTo: true)
        .getDocuments();
    return snapshot.documents
        .map((x) => AchievementModel.fromAchievement(
            Achievement.fromDocument(x, _authService.currentUser.id)))
        .toList();
  }

  Future<AchievementModel> createAchievement({
    @required AchievementModel achievement,
    UserModel user,
    TeamModel team,
  }) async {
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

    var imageData = await _imageService.uploadImage(achievement.imageFile);

    final docRef = await _database
        .collection(_achievementsCollection)
        .add(Achievement.createMap(
          name: achievement.name,
          description: achievement.description,
          isActive: true,
          imageName: imageData?.name,
          imageUrl: imageData?.url,
          userReference: userReference,
          teamReference: teamReference,
          team: team,
        ));

    final document = await docRef.get();
    return AchievementModel.fromAchievement(
        Achievement.fromDocument(document, _authService.currentUser.id));
  }

  Future<AchievementModel> _updateAchievement({
    @required String id,
    @required Map<String, dynamic> data,
    WriteBatch batch,
  }) async {
    final docRef = _database.collection(_achievementsCollection).document(id);
    if (batch == null) {
      await docRef.setData(data, merge: true);

      final document = await docRef.get();
      return AchievementModel.fromAchievement(
          Achievement.fromDocument(document, _authService.currentUser.id));
    } else {
      batch.setData(docRef, data, merge: true);
      return null;
    }
  }

  Future<AchievementModel> updateAchievement({
    @required AchievementModel achievement,
    bool isActive,
    WriteBatch batch,
  }) async {
    ImageData imageData;

    if (achievement.imageFile != null) {
      imageData = await _imageService.uploadImage(achievement.imageFile);
    }

    final data = Achievement.createMap(
      imageUrl: imageData?.url,
      imageName: imageData?.name,
      name: achievement.name,
      description: achievement.description,
      isActive: isActive,
    );

    return _updateAchievement(id: achievement.id, data: data, batch: batch);
  }

  Future<AchievementModel> transferAchievement({
    @required String id,
    TeamModel team,
    UserModel user,
    WriteBatch batch,
  }) async {
    UserReference userReference;
    TeamReference teamReference;
    if (user != null && team != null) {
      throw ArgumentError("Team and user can't be set simultaneously");
    } else if (user != null) {
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
      team: team,
    );
    return _updateAchievement(id: id, data: data, batch: batch);
  }

  Future<void> deleteAchievement(
    String id, {
    int holdersCount,
    WriteBatch batch,
  }) {
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

  Future<void> sendAchievement(
      UserModel recipient, AchievementModel achievement, String comment) async {
    var sender = _authService.currentUser;
    final timestamp = Timestamp.now();

    final batch = _database.batch();

    // add an achievement to user's achievements

    final userAchievementsReference = _database
        .collection("users/${recipient.id}/$_achievementReferencesCollection");

    final userAchievementMap = UserAchievement(
      sender: UserReference.fromUser(sender),
      achievement: RelatedAchievement.fromAchievementModel(achievement),
      comment: comment,
      date: timestamp,
    ).toMap();

    batch.setData(userAchievementsReference.document(), userAchievementMap);

    // add a user to achievements

    final achievementHoldersReference = _database
        .collection("$_achievementsCollection/${achievement.id}/holders");

    final holderMap = AchievementHolder(
      date: timestamp,
      recipient: UserReference.fromUser(recipient),
    ).toMap();

    batch.setData(achievementHoldersReference.document(), holderMap);

    await batch.commit();
  }

  Future<List<UserAchievementModel>> getUserAchievements(String userId) async {
    final queryResult = await _database
        .collection("users/$userId/$_achievementReferencesCollection")
        .getDocuments();
    final userAchievements = queryResult.documents
        .map((x) => UserAchievementModel.fromUserAchievement(
            UserAchievement.fromDocument(x)))
        .toList();
    return userAchievements;
  }

  Future<List<UserModel>> getAchievementHolders(String achivementId) async {
    final queryResult = await _database
        .collection("$_achievementsCollection/$achivementId/holders")
        .getDocuments();
    final achievementHolders = queryResult.documents
        .map((x) => AchievementHolder.fromDocument(x))
        .toSet()
        .map((ah) => UserModel.fromUserReference(ah.recipient))
        .toList();
    return achievementHolders;
  }

  Future<AchievementModel> getAchievement(String achivementId) async {
    final documentSnapshot = await _database
        .collection(_achievementsCollection)
        .document(achivementId)
        .get();
    return AchievementModel.fromAchievement(Achievement.fromDocument(
        documentSnapshot, _authService.currentUser.id));
  }

  Future<List<AchievementModel>> getTeamAchievements(String teamId) {
    return _getAchievements("team.id", teamId);
  }

  Future<List<AchievementModel>> getMyAchievements() {
    final userId = _authService.currentUser.id;
    return _getAchievements("user.id", userId);
  }

  Future<List<AchievementModel>> _getAchievements(
      String field, String value) async {
    final qs = await _database
        .collection(_achievementsCollection)
        .where(field, isEqualTo: value)
        .where("is_active", isEqualTo: true)
        .getDocuments();
    final result = qs.documents
        .map((x) => AchievementModel.fromAchievement(
            Achievement.fromDocument(x, _authService.currentUser.id)))
        .toList();
    return result;
  }
}
