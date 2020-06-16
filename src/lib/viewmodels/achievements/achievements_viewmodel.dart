import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/messages/achievement_deleted_message.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/database/achievements_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class AchievementsViewModel extends BaseViewModel {
  final achievements = List<AchievementModel>();

  final _eventBus = locator<EventBus>();
  final _achievementsService = locator<AchievementsService>();

  StreamSubscription _achievementDeletedSubscription;

  Future<void> initialize() async {
    isBusy = true;

    var result = await _achievementsService.getAchievements();
    achievements.forEach((x) => x.dispose());
    achievements.clear();
    achievements.addAll(result.map((x) => AchievementModel(x)));

    _achievementDeletedSubscription?.cancel();
    _achievementDeletedSubscription =
        _eventBus.on<AchievementDeletedMessage>().listen(_onAchievementDeleted);

    isBusy = false;

    notifyListeners();
  }

  void _onAchievementDeleted(AchievementDeletedMessage event) {
    achievements.removeWhere(
        (element) => event.ids.contains(element.achievement.id));
    notifyListeners();
  }

  @override
  void dispose() {
    _achievementDeletedSubscription?.cancel();
    achievements.forEach((x) => x.dispose());
    super.dispose();
  }
}
