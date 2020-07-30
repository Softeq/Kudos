import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/models/messages/achievement_sent_message.dart';
import 'package:kudosapp/models/user_achievement_collection.dart';
import 'package:kudosapp/models/user_achievement_model.dart';
import 'package:kudosapp/pages/achievements/achievement_details_page.dart';
import 'package:kudosapp/pages/profile/received_achievement_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:sortedmap/sortedmap.dart';

class ProfileAchievementsViewModel extends BaseViewModel {
  final _eventBus = locator<EventBus>();
  final _authService = locator<BaseAuthService>();
  final _achievementsService = locator<AchievementsService>();

  final String _userId;
  final _achievementsMap =
      SortedMap<String, UserAchievementCollection>(Ordering.byValue());

  StreamSubscription<AchievementSentMessage> _achievementReceivedSubscription;

  bool get hasAchievements => _achievementsMap.isNotEmpty;
  bool get isMyProfile => _userId == _authService.currentUser.id;

  ProfileAchievementsViewModel(this._userId) {
    _initialize();
  }

  void _initialize() async {
    isBusy = true;

    final allUserAchievements =
        await _achievementsService.getReceivedAchievements(_userId);

    for (final userAchievement in allUserAchievements) {
      _addUserAchievementToMap(userAchievement);
    }

    _achievementReceivedSubscription?.cancel();
    _achievementReceivedSubscription =
        _eventBus.on<AchievementSentMessage>().listen(_onAchievementReceived);

    isBusy = false;
  }

  List<UserAchievementCollection> getAchievements() =>
      _achievementsMap.values.toList();

  void openAchievementDetails(
      BuildContext context, UserAchievementCollection achievementCollection) {
    if (isMyProfile) {
      Navigator.of(context).push(
        ReceivedAchievementRoute(achievementCollection),
      );
    } else {
      final achievement = achievementCollection.relatedAchievement;
      Navigator.of(context).push(AchievementDetailsRoute(achievement));
    }
  }

  void _addUserAchievementToMap(UserAchievementModel userAchievement) {
    final id = userAchievement.achievement.id;
    if (_achievementsMap.containsKey(id)) {
      _achievementsMap[id] =
          _achievementsMap[id].addAchievement(userAchievement);
    } else {
      _achievementsMap[id] = UserAchievementCollection.single(userAchievement);
    }
  }

  void _onAchievementReceived(AchievementSentMessage event) {
    if (event.recipient.id != _userId) {
      return;
    }

    _addUserAchievementToMap(event.userAchievement);
    notifyListeners();
  }

  @override
  void dispose() {
    _achievementReceivedSubscription.cancel();
    super.dispose();
  }
}
