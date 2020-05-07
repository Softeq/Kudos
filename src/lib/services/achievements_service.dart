import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/achievement_category.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';

class AchievementsService {
  final LocalizationService _localizationService =
      locator<LocalizationService>();

  Future<List<Achievement>> getAchievements() {
    var completer = Completer<List<Achievement>>();
    StreamSubscription subscription;
    subscription =
        Firestore.instance.collection("achievements").snapshots().listen(
      (s) {
        var result = s.documents.map((x) {
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

        completer.complete(result);
        subscription?.cancel();
      },
    );

    return completer.future;
  }

  List<String> _toString(List<dynamic> input) {
    if (input == null) {
      return List<String>();
    } else {
      return input.cast<String>().toList();
    }
  }
}
