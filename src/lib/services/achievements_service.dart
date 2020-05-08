import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/achievement_category.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';

class AchievementsService {
  final LocalizationService _localizationService =
      locator<LocalizationService>();
  final Firestore database = Firestore.instance;

  Future<List<Achievement>> getAchievements() {
    var completer = Completer<List<Achievement>>();
    StreamSubscription subscription;
    subscription = database.collection("achievements").snapshots().listen(
      (s) {
        var result = _map(s.documents);
        completer.complete(result);
        subscription?.cancel();
      },
    );

    return completer.future;
  }

  List<Achievement> _map(List<DocumentSnapshot> queryResult) {
    var result = queryResult.map((x) {
      return Achievement(
        id: x.documentID,
        tags: _toString(x.data["tag"]),
        name: x.data["name"],
        imageUrl: x.data["imageUrl"],
      );
    }).toList();

    var categories = [
      AchievementCategory(
        id: "fromCris",
        name: _localizationService.fromCris,
        orderIndex: 1,
      ),
      AchievementCategory(
        id: "official",
        name: _localizationService.official,
        orderIndex: 2,
      ),
      AchievementCategory(
        id: "others",
        name: _localizationService.others,
        orderIndex: 3,
      ),
    ];

    var categoriesMap = Map.fromEntries(
      categories.map((x) => MapEntry<String, AchievementCategory>(x.id, x)),
    );

    result.forEach((x) {
      var categoryKey = "others";
      if (x.tags.isNotEmpty) {
        if (x.tags.contains("fromCris")) {
          categoryKey = "fromCris";
        } else if (x.tags.contains("official")) {
          categoryKey = "official";
        }
      }

      x.category = categoriesMap[categoryKey];
    });

    return result;
  }

  List<String> _toString(List<dynamic> input) {
    if (input == null) {
      return List<String>();
    } else {
      return input.cast<String>().toList();
    }
  }

  Future<void> addAchievement(String userId, String achievementId) async {
    final collection = database.collection("users/$userId/achievements");

    await collection.add({
      "id": achievementId,
    });
  }

  Future<List<Achievement>> getUserAchievements(String userId) async {
    final userAchievementsCollection = database.collection("users/$userId/achievements");
    final userQueryResult = await userAchievementsCollection.getDocuments();
    final userAchievements = userQueryResult.documents.map((x) => x.data["id"]).toList();

    // TODO YP: need better solution
    final allAchievementsCollection = database.collection("achievements");
    final allQueryResult = await allAchievementsCollection.getDocuments();
    final allAchievements = _map(allQueryResult.documents);

    allAchievements.removeWhere((x) => !userAchievements.contains(x.id));

    return allAchievements;
  }
}
