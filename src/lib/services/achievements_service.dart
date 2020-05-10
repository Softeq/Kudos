import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kudosapp/core/errors/upload_file_error.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/user.dart';
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
      var firebaseStorage = FirebaseStorage.instance;
      var storageReference =
          firebaseStorage.ref().child(_kudosFolder).child("${Uuid().v4()}.svg");
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

  Future<void> sendAchievement(
      User sender,
      User recipient,
      Achievement achievement,
      String comment,
    ) async {

    final timestamp = Timestamp.now();

    final batch = database.batch();

    // add an achievement to user's achievements

    final userAchievementsReference =
        database.collection("users/${recipient.id}/achievements");

    batch.setData(userAchievementsReference.document(), {
      "id": achievement.id,
      "name": achievement.name,
      "imageUrl": achievement.imageUrl,
      "date": timestamp,
      "comment": comment,
      "sender_user": {
        "id": sender.id,
        "name": sender.name,
        "imageUrl": sender.imageUrl,
      },
    });

    // add a user to achievements

    final achievementHoldersReference =
        database.collection("achievements/${achievement.id}/holders");

    // TODO YP: can be made via Cloud Functions Triggers
    batch.setData(achievementHoldersReference.document(), {
      "id": recipient.id,
      "name": recipient.name,
      "imageUrl": recipient.imageUrl,
      "date": timestamp,
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
}
