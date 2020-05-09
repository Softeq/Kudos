import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kudosapp/core/errors/upload_file_error.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:uuid/uuid.dart';

class AchievementsService {
  final String _achievementsCollection = "achievements";
  final String _kudosFolder = "kudos";

  Future<List<Achievement>> getAchievements() async {
    var completer = Completer<List<Achievement>>();
    var firestore = await locator.getAsync<Firestore>();
    StreamSubscription subscription;
    subscription =
        firestore.collection(_achievementsCollection).snapshots().listen(
      (s) {
        var result = s.documents.map(_fromDocument).toList();
        completer.complete(result);
        subscription?.cancel();
      },
    );

    return completer.future;
  }

  Future<void> createAchievement(Achievement achievement, File file) async {
    if (file == null) {
      throw ArgumentError.notNull("file");
    }

    if (achievement.name == null || achievement.name == "") {
      throw ArgumentError.notNull("name");
    }

    if (achievement.description == null || achievement.description == "") {
      throw ArgumentError.notNull("description");
    }

    //var firebaseStorage = await locator.getAsync<FirebaseStorage>();
    var firebaseStorage = FirebaseStorage.instance;
    var storageReference =
        firebaseStorage.ref().child(_kudosFolder).child("${Uuid().v4()}.svg");
    var storageUploadTask = storageReference.putFile(file);
    var storageTaskSnapshot = await storageUploadTask.onComplete;

    if (storageTaskSnapshot.error != null) {
      throw UploadFileError();
    }
    var imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

    var firestore = await locator.getAsync<Firestore>();
    await firestore.collection(_achievementsCollection).add({
      "name": achievement.name,
      "imageUrl": imageUrl,
      "description": achievement.description,
    });
  }

  Achievement _fromDocument(DocumentSnapshot x) {
    return Achievement(
      description: x.data["description"],
      tags: _toString(x.data["tag"]),
      name: x.data["name"],
      imageUrl: x.data["imageUrl"],
      id: x.documentID,
    );
  }

  List<String> _toString(List<dynamic> input) {
    if (input == null) {
      return List<String>();
    } else {
      return input.cast<String>().toList();
    }
  }
}
