import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kudosapp/core/errors/upload_file_error.dart';
import 'package:kudosapp/models/achievement.dart';
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

  Future<void> addAchievement(String userId, String achievementId) async {
    final collection = database.collection("users/$userId/achievements");

    await collection.add({
      "id": achievementId,
    });
  }

  Future<List<Achievement>> getUserAchievements(String userId) async {
    final userAchievementsCollection =
        database.collection("users/$userId/achievements");
    final userQueryResult = await userAchievementsCollection.getDocuments();
    final userAchievements =
        userQueryResult.documents.map((x) => x.data["id"]).toList();

    // TODO YP: need better solution
    final allAchievementsCollection = database.collection("achievements");
    final allQueryResult = await allAchievementsCollection.getDocuments();
    final allAchievements = allQueryResult.documents
        .map((x) => Achievement.fromDocument(x))
        .toList();

    allAchievements.removeWhere((x) => !userAchievements.contains(x.id));

    return allAchievements;
  }
}
