import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosapp/models/achievement.dart';

class AchievementsService {
  Future<List<Achievement>> getAchievements() {
    var completer = Completer<List<Achievement>>();

    Firestore.instance.collection("achievements").snapshots().listen((s) {
      var result = s.documents.map((x) {
        return Achievement(
          groupName: "test group",
          name: x.data["name"],
        );
      }).toList();
      completer.complete(result);
    });

    return completer.future;
  }
}
