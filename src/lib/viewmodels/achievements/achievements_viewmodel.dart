import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/models/messages/achievement_deleted_message.dart';
import 'package:kudosapp/models/messages/achievement_transferred_message.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/database/achievements_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class AchievementsViewModel extends BaseViewModel {
  final _eventBus = locator<EventBus>();
  final _achievementsService = locator<AchievementsService>();
  final _authService = locator<BaseAuthService>();

  StreamSubscription _achievementUpdatedSubscription;
  StreamSubscription _achievementDeletedSubscription;
  StreamSubscription _achievementTransferredSubscription;

  final _achievements = ListNotifier<AchievementModel>();

  ListNotifier<AchievementModel> get achievements => _achievements;

  User get currentUser => _authService.currentUser;

  Future<void> initialize() async {
    isBusy = true;

    var myAchievements = await _achievementsService.getMyAchievements();
    var teamsAchievements = await _achievementsService.getAchievements();
    _achievements.items.forEach((x) => x.dispose());
    _achievements.items.clear();
    _achievements.items.addAll(myAchievements.map((x) => AchievementModel(x)));
    _achievements.items
        .addAll(teamsAchievements.map((x) => AchievementModel(x)));
    _achievements.notifyListeners();

    _achievementUpdatedSubscription?.cancel();
    _achievementUpdatedSubscription =
        _eventBus.on<AchievementUpdatedMessage>().listen(_onAchievementUpdated);

    _achievementDeletedSubscription?.cancel();
    _achievementDeletedSubscription =
        _eventBus.on<AchievementDeletedMessage>().listen(_onAchievementDeleted);

    _achievementTransferredSubscription?.cancel();
    _achievementTransferredSubscription = _eventBus
        .on<AchievementTransferredMessage>()
        .listen(_onAchievementTransferred);

    isBusy = false;
  }

  void _onAchievementUpdated(AchievementUpdatedMessage event) {
    if (event.achievement.userReference?.id != currentUser.id &&
        event.achievement.teamReference == null) {
      return;
    }

    var achievementModel = _achievements.items.firstWhere(
      (x) => x.achievement.id == event.achievement.id,
      orElse: () => null,
    );
    if (achievementModel != null) {
      achievementModel.initialize(event.achievement);
      _achievements.notifyListeners();
    } else {
      _achievements.add(AchievementModel(event.achievement));
    }
  }

  void _onAchievementDeleted(AchievementDeletedMessage event) {
    _achievements.items
        .removeWhere((element) => event.ids.contains(element.achievement.id));
    _achievements.notifyListeners();
  }

  void _onAchievementTransferred(AchievementTransferredMessage event) {
    var achievementIds = event.achievements.map((a) => a.id).toSet();
    _achievements.items.removeWhere(
        (element) => achievementIds.contains(element.achievement.id));

    if (event.achievements.first.userReference?.id == currentUser.id ||
        event.achievements.first.teamReference != null) {
      for (var achievement in event.achievements) {
        _achievements.items.add(AchievementModel(achievement));
      }
    }

    _achievements.notifyListeners();
  }

  @override
  void dispose() {
    _achievementUpdatedSubscription?.cancel();
    _achievementDeletedSubscription?.cancel();
    _achievementTransferredSubscription?.cancel();

    _achievements.items.forEach((x) => x.dispose());
    _achievements.items.clear();
    super.dispose();
  }
}
