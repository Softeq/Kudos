import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/achievement_category.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/achievement_item_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class AchievementsViewModel extends BaseViewModel {
  final AchievementsService _achievementsService =
      locator<AchievementsService>();
  final LocalizationService _localizationService =
      locator<LocalizationService>();
  final List<AchievementItemViewModel> achievements = List<AchievementItemViewModel>();

  AchievementsViewModel() {
    isBusy = true;
  }

  Future<void> initialize() async {
    var result = await _achievementsService.getAchievements();
    var map = _getCategoriesMap();
    var viewModels = result.map((x) => _map(x, map)).toList();
    achievements.addAll(viewModels);
    isBusy = false;
    notifyListeners();
  }

  @override
  void dispose() {
    achievements.forEach((x) => x.dispose());
    super.dispose();
  }

  Map<String, AchievementCategory> _getCategoriesMap() {
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

    return categoriesMap;
  }

  AchievementItemViewModel _map(
      Achievement x, Map<String, AchievementCategory> categoriesMap) {
    var categoryKey = "others";
    if (x.tags.isNotEmpty) {
      if (x.tags.contains("fromCris")) {
        categoryKey = "fromCris";
      } else if (x.tags.contains("official")) {
        categoryKey = "official";
      }
    }

    var category = categoriesMap[categoryKey];

    return AchievementItemViewModel(
      achievement: x,
      category: category,
    );
  }
}
