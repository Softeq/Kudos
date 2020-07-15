import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosapp/dto/achievement.dart';
import 'package:kudosapp/dto/achievement_holder.dart';
import 'package:kudosapp/dto/user_achievement.dart';

class AchievementsDatabaseService {
  static const _usersCollection = "users";
  static const _achievementsCollection = "achievements";
  static const _achievementReferencesCollection = "achievement_references";
  static const _achievementHoldersCollection = "holders";

  final _database = Firestore.instance;

  Future<Iterable<Achievement>> _getAchievements(String field, String value) {
    return _database
        .collection(_achievementsCollection)
        .where(field, isEqualTo: value)
        .where("is_active", isEqualTo: true)
        .getDocuments()
        .then((value) => value.documents
            .map((d) => Achievement.fromJson(d.data, d.documentID)));
  }

  Future<Iterable<Achievement>> getTeamsAchievements() {
    return _database
        .collection(_achievementsCollection)
        .where("user", isNull: true)
        .where("is_active", isEqualTo: true)
        .getDocuments()
        .then((value) => value.documents
            .map((d) => Achievement.fromJson(d.data, d.documentID)));
  }

  Future<Iterable<Achievement>> getTeamAchievements(String teamId) {
    return _getAchievements("team.id", teamId);
  }

  Future<Iterable<Achievement>> getUserAchievements(String userId) {
    return _getAchievements("user.id", userId);
  }

  Future<Achievement> getAchievement(String achivementId) {
    return _database
        .collection(_achievementsCollection)
        .document(achivementId)
        .get()
        .then((value) => Achievement.fromJson(value.data, value.documentID));
  }

  Future<Iterable<AchievementHolder>> getAchievementHolders(
      String achivementId) {
    return _database
        .collection(
            "$_achievementsCollection/$achivementId/$_achievementHoldersCollection")
        .getDocuments()
        .then((value) =>
            value.documents.map((d) => AchievementHolder.fromJson(d.data)));
  }

  Future<void> createAchievementHolder(
      String achievementId, AchievementHolder achievementHolder,
      {WriteBatch batch}) {
    final docRef = _database
        .collection("$_achievementsCollection/$achievementId/holders")
        .document();

    final holderMap = achievementHolder.toMap();

    if (batch == null) {
      return docRef.setData(holderMap);
    } else {
      batch.setData(docRef, holderMap);
      return null;
    }
  }

  Future<void> createUserAchievement(
      String recipientId, UserAchievement userAchievement,
      {WriteBatch batch}) {
    final docRef = _database
        .collection(
            "$_usersCollection/$recipientId/$_achievementReferencesCollection")
        .document();

    if (batch == null) {
      return docRef.setData(userAchievement.toJson());
    } else {
      batch.setData(docRef, userAchievement.toJson());
      return null;
    }
  }

  Future<Achievement> createAchievement(Achievement achievement) {
    return _database
        .collection(_achievementsCollection)
        .add(achievement.toJson(addAll: true))
        .then((value) => value.get())
        .then((value) => Achievement.fromJson(value.data, value.documentID));
  }

  Future<Iterable<UserAchievement>> getReceivedAchievements(
      String userId) async {
    return _database
        .collection(
            "$_usersCollection/$userId/$_achievementReferencesCollection")
        .getDocuments()
        .then((value) => value.documents
            .map((d) => UserAchievement.fromJson(d.data, d.documentID)));
  }

  Future<Achievement> updateAchievement(
    Achievement achievement, {
    bool updateMetadata = false,
    bool updateImage = false,
    bool updateOwner = false,
    bool updateIsActive = false,
    WriteBatch batch,
  }) {
    final docRef =
        _database.collection(_achievementsCollection).document(achievement.id);
    final map = achievement.toJson(
      addMetadata: updateMetadata,
      addImage: updateImage,
      addOwner: updateOwner,
      addIsActive: updateIsActive,
    );
    if (batch == null) {
      return docRef
          .setData(map, merge: true)
          .then((value) => docRef.get())
          .then((value) => Achievement.fromJson(value.data, value.documentID));
    } else {
      batch.setData(docRef, map, merge: true);
      return null;
    }
  }

  Future<void> deleteAchievement(String achievementId) {
    return _database
        .collection(_achievementsCollection)
        .document(achievementId)
        .delete();
  }
}
