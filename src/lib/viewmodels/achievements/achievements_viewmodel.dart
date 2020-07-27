import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/achievement_owner_model.dart';
import 'package:kudosapp/helpers/list_notifier.dart';
import 'package:kudosapp/models/messages/achievement_deleted_message.dart';
import 'package:kudosapp/models/messages/achievement_transferred_message.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/pages/achievements/achievement_details_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class AchievementsViewModel extends BaseViewModel {
  final _eventBus = locator<EventBus>();
  final _authService = locator<BaseAuthService>();
  final _achievementsService = locator<AchievementsService>();

  StreamSubscription _achievementUpdatedSubscription;
  StreamSubscription _achievementDeletedSubscription;
  StreamSubscription _achievementTransferredSubscription;

  final achievements = ListNotifier<AchievementModel>();
  final bool Function(AchievementModel) _achievementFilter;

  UserModel get currentUser => _authService.currentUser;

  AchievementsViewModel({bool Function(AchievementModel) achievementsFilter})
      : _achievementFilter = achievementsFilter {
    _initialize();
  }

  void _initialize() async {
    try {
      isBusy = true;

      final loadedAchievements = await _achievementsService.getAchievements();

      achievements.items.clear();
      achievements.items.addAll(_achievementFilter == null
          ? loadedAchievements
          : loadedAchievements.where(_achievementFilter));
      achievements.notifyListeners();

      _achievementUpdatedSubscription?.cancel();
      _achievementUpdatedSubscription = _eventBus
          .on<AchievementUpdatedMessage>()
          .listen(_onAchievementUpdated);

      _achievementDeletedSubscription?.cancel();
      _achievementDeletedSubscription = _eventBus
          .on<AchievementDeletedMessage>()
          .listen(_onAchievementDeleted);

      _achievementTransferredSubscription?.cancel();
      _achievementTransferredSubscription = _eventBus
          .on<AchievementTransferredMessage>()
          .listen(_onAchievementTransferred);
    } finally {
      isBusy = false;
    }
  }

  void onAchievementClicked(
      BuildContext context, AchievementModel achievement) {
    Navigator.of(context)
        .push(AchievementDetailsRoute(achievement))
        .whenComplete(() => notifyListeners());
  }

  void _onAchievementUpdated(AchievementUpdatedMessage event) {
    if (event.achievement.owner.type == AchievementOwnerType.user &&
        event.achievement.owner.id != currentUser.id) {
      return;
    }

    final index = achievements.items.indexWhere(
      (x) => x.id == event.achievement.id,
    );
    if (index != -1) {
      achievements.items.removeAt(index);
      achievements.items.insert(index, event.achievement);
      achievements.notifyListeners();
    } else {
      achievements.add(event.achievement);
    }
  }

  void _onAchievementDeleted(AchievementDeletedMessage event) {
    achievements.items.removeWhere((x) => event.ids.contains(x.id));
    achievements.notifyListeners();
  }

  void _onAchievementTransferred(AchievementTransferredMessage event) {
    var achievementIds = event.achievements.map((a) => a.id).toSet();
    achievements.items.removeWhere((x) => achievementIds.contains(x.id));

    if (event.achievements.first.owner.type == AchievementOwnerType.team ||
        event.achievements.first.owner.id == currentUser.id) {
      for (var achievement in event.achievements) {
        achievements.items.add(achievement);
      }
    }

    achievements.notifyListeners();
  }

  @override
  void dispose() {
    _achievementUpdatedSubscription?.cancel();
    _achievementDeletedSubscription?.cancel();
    _achievementTransferredSubscription?.cancel();

    achievements.dispose();
    super.dispose();
  }
}
