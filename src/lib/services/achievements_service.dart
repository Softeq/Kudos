import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kudosapp/core/errors/upload_file_error.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/achievement_user.dart';
import 'package:kudosapp/models/user_achievement.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class AchievementsService {
  final Firestore database = Firestore.instance;
  final String _achievementsCollection = "achievements";
  final String _kudosFolder = "kudos";

  Future<List<Achievement>> getAchievements() async {
    var completer = Completer<List<Achievement>>();
    StreamSubscription subscription;
    subscription =
        database.collection(_achievementsCollection).snapshots().listen(
      (s) {
        var result =
            s.documents.map((x) => Achievement.fromDocument(x)).toList();
        completer.complete(result);
        subscription?.cancel();
      },
    );

    return completer.future;
  }

  Future<void> createOrUpdate(Achievement achievement, [File file]) async {
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

    if (file != null) {
      var fileExtension = path.extension(file.path);
      var firebaseStorage = FirebaseStorage.instance;
      var storageReference =
          firebaseStorage.ref().child(_kudosFolder).child("${Uuid().v4()}$fileExtension");
      var storageUploadTask = storageReference.putFile(file);
      var storageTaskSnapshot = await storageUploadTask.onComplete;

      if (storageTaskSnapshot.error != null) {
        throw UploadFileError();
      }

      var imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
      copyOfAchievement = copyOfAchievement.copy(imageUrl: imageUrl);
    }

    if (copyOfAchievement.id == null) {
      await database
          .collection(_achievementsCollection)
          .add(copyOfAchievement.toMap());
    } else {
      await database
          .collection(_achievementsCollection)
          .document(copyOfAchievement.id)
          .setData(copyOfAchievement.toMap());
    }
  }

  Future<void> sendAchievement(UserAchievement userAchievement) async {

    final timestamp = Timestamp.now();

    final batch = database.batch();

    // add an achievement to user's achievements

    final userAchievementsReference =
        database.collection("users/${userAchievement.recipient.id}/achievements");

    var map = userAchievement.toMap();
    map.putIfAbsent("date", () => timestamp);

    batch.setData(userAchievementsReference.document(), map);

    // add a user to achievements

    // TODO YP: can be made via Cloud Functions Triggers

    final achievementHoldersReference =
        database.collection("achievements/${userAchievement.achievement.id}/holders");

    batch.setData(achievementHoldersReference.document(), {
      "date": timestamp,
      "recipient": userAchievement.recipient.toMapForUserAchievement(),
    });

    await batch.commit();
  }

  Future<List<Achievement>> getUserAchievements(String userId) async {
    final userAchievementsCollection =
        database.collection("users/$userId/achievements");

    final queryResult = await userAchievementsCollection.getDocuments();

    final userAchievements =
        queryResult.documents.map((x) => Achievement.fromDocument(x)).toList();

    return userAchievements;
  }

  Future<List<AchievementUser>> getAchievementUsers(String achivementId) async {
    final achievementHoldersCollection =  
        database.collection("achievements/$achivementId/holders");

    final queryResult = await achievementHoldersCollection.getDocuments();

    final achievementUsers =
        queryResult.documents.map((x) => AchievementUser.fromDocument(x)).toList();

    return achievementUsers;
  }
}
