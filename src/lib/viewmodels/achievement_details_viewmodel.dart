import 'dart:math';

import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/viewmodels/achievement_item_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class AchievementDetailsViewModel extends BaseViewModel {
  AchievementItemViewModel _achievementViewModel;
  double _statisticsValue;

  AchievementItemViewModel get achievementViewModel => _achievementViewModel;

  double get statisticsValue => _statisticsValue;

  void initialize(Achievement achievement) {
    _achievementViewModel = AchievementItemViewModel(
      achievement: achievement,
      category: null,
    );

    loadStatistics();

    notifyListeners();
  }

  void loadStatistics() {
    // Number of users with this badge divided by the total number of users 
    // TODO PS: Load data here
    var rng = new Random();
    _statisticsValue = rng.nextDouble();
  }

  @override
  void dispose() {
    _achievementViewModel.dispose();
    super.dispose();
  }
}