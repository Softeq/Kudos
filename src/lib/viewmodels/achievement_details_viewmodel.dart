import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/achievement_holder.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/viewmodels/achievement_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class AchievementDetailsViewModel extends BaseViewModel {
  final _achievementsService = locator<AchievementsService>();
  final _peopleService = locator<PeopleService>();
  final _eventBus = locator<EventBus>();

  StreamSubscription<AchievementUpdatedMessage> _subscription;
  List<AchievementHolder> _achievementHolders;
  AchievementViewModel _achievementViewModel;
  double _statisticsValue = 0;

  AchievementDetailsViewModel() {
    isBusy = true;
  }

  AchievementViewModel get achievementViewModel => _achievementViewModel;

  List<AchievementHolder> get achievementHolders => _achievementHolders;

  double get statisticsValue => _statisticsValue;

  Future<void> initialize(Achievement achievement) async {
    _achievementViewModel = AchievementViewModel(achievement);
    _subscription?.cancel();
    _subscription =
        _eventBus.on<AchievementUpdatedMessage>().listen(_onAchievementUpdated);
    await loadStatistics();
  }

  Future<void> loadStatistics() async {
    // Number of users with this badge divided by the total number of users
    _achievementHolders = await _achievementsService
        .getAchievementHolders(achievementViewModel.achievement.id);
    var allUsers = await _peopleService.getAllUsers();
    _statisticsValue =
        allUsers.length == 0 ? 0 : _achievementHolders.length / allUsers.length;
    isBusy = false;
  }

  @override
  void dispose() {
    _achievementViewModel.dispose();
    _subscription.cancel();
    super.dispose();
  }

  void _onAchievementUpdated(AchievementUpdatedMessage event) {
    _achievementViewModel.initialize(event.achievement);
    notifyListeners();
  }
}
