import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/extensions/list_extensions.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/messages/achievement_sent_message.dart';
import 'package:kudosapp/models/messages/achievement_viewed_message.dart';
import 'package:kudosapp/models/user_achievement_collection.dart';
import 'package:kudosapp/models/user_achievement_model.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/data_services/achievements_service.dart';
import 'package:kudosapp/services/data_services/users_service.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/services/navigation_service.dart';
import 'package:kudosapp/viewmodels/achievements/achievement_details_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:kudosapp/viewmodels/users/received_achievement_viewmodel.dart';

class ProfileAchievementsViewModel extends BaseViewModel {
  final _eventBus = locator<EventBus>();
  final _authService = locator<BaseAuthService>();
  final _dialogsService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  final _achievementsService = locator<AchievementsService>();
  final _usersService = locator<UsersService>();

  final String _userId;
  final _receivedAchievements = Map<String, UserAchievementCollection>();

  Map<String, AchievementModel> _accessibleAchievementsMap;
  StreamSubscription<AchievementSentMessage> _achievementReceivedSubscription;
  StreamSubscription<AchievementViewedMessage> _achievementViewedSubscription;
  UserModel _userModel;

  bool get hasAchievements => _receivedAchievements.isNotEmpty;

  bool get isMyProfile => _userId == _authService.currentUser.id;

  ProfileAchievementsViewModel(this._userId) {
    _initialize();
  }

  void _initialize() async {
    try {
      isBusy = true;

      _userModel = await _usersService.getUser(_userId);

      _accessibleAchievementsMap =
          await _achievementsService.getAchievementsMap();

      final allUserAchievements =
          await _achievementsService.getReceivedAchievements(_userId);

      for (final userAchievement in allUserAchievements) {
        _addUserAchievementToMap(userAchievement);
      }

      _achievementReceivedSubscription?.cancel();
      _achievementReceivedSubscription =
          _eventBus.on<AchievementSentMessage>().listen(_onAchievementReceived);

      _achievementViewedSubscription?.cancel();
      _achievementViewedSubscription =
          _eventBus.on<AchievementViewedMessage>().listen(_onAchievementViewed);
    } finally {
      isBusy = false;
    }
  }

  List<UserAchievementCollection> getAchievements() {
    var result = _receivedAchievements.values.toList();

    if (_userModel.achievementsOrdering != null) {
      final orderedMap = Map.fromEntries(
        _userModel.achievementsOrdering.asMap().entries.map(
          (x) {
            return MapEntry(x.value, x.key);
          },
        ),
      );

      final listProxy = result.map(
        (x) {
          var index = orderedMap[x.relatedAchievement.id];

          if (index == null) {
            index = result.length;
          }

          return _ItemWithOrderIndex(index, x);
        },
      ).toList();

      listProxy.sortThen(
        (x, y) {
          return x.index.compareTo(y.index);
        },
        (x, y) {
          return x.collection.compareTo(y.collection);
        },
      );

      result = listProxy.map((x) => x.collection).toList();
    } else {
      result.sort(
        (x, y) {
          return x.compareTo(y);
        },
      );
    }

    return result;
  }

  void openAchievementDetails(
    BuildContext context,
    UserAchievementCollection achievementCollection,
  ) {
    var achievement =
        _accessibleAchievementsMap[achievementCollection.relatedAchievement.id];

    if (isMyProfile) {
      _navigationService.navigateTo(
        ReceivedAchievementViewModel(achievementCollection),
      );
    } else if (achievement == null) {
      _dialogsService.showOkDialog(
        context: context,
        title: localizer().accessDenied,
        content: localizer().privateAchievement,
      );
    } else {
      final achievement = achievementCollection.relatedAchievement;
      _navigationService.navigateTo(
        AchievementDetailsViewModel(achievement),
      );
    }
  }

  void saveOrdering(int i, int j) {
    final list = getAchievements();
    final item = list[i];

    list.remove(item);
    if (i > j) {
      list.insert(j, item);
    } else {
      list.insert(j - 1, item);
    }

    _userModel.achievementsOrdering = list.map((x) => x.relatedAchievement.id).toList();
    _usersService.updateOrdering(_userModel);

    notifyListeners();
  }

  @override
  void dispose() {
    _achievementReceivedSubscription.cancel();
    _achievementViewedSubscription.cancel();
    super.dispose();
  }

  void _addUserAchievementToMap(UserAchievementModel userAchievement) {
    final id = userAchievement.achievement.id;
    if (_receivedAchievements.containsKey(id)) {
      _receivedAchievements[id] =
          _receivedAchievements[id].addAchievement(userAchievement);
    } else {
      _receivedAchievements[id] =
          UserAchievementCollection.single(userAchievement);
    }

    if (isMyProfile) {
      _receivedAchievements[id].isAccessible = true;
    } else {
      final accessibleAchievement = _accessibleAchievementsMap[id];
      _receivedAchievements[id].isAccessible = accessibleAchievement != null;
    }
  }

  void _onAchievementReceived(AchievementSentMessage event) {
    if (event.recipient.id != _userId) {
      return;
    }

    _addUserAchievementToMap(event.userAchievement);
    notifyListeners();
  }

  void _onAchievementViewed(AchievementViewedMessage event) {
    final id = event.achievement.id;
    if (_receivedAchievements.containsKey(id)) {
      _receivedAchievements[id].hasNew = false;
      notifyListeners();
    }
  }
}

class _ItemWithOrderIndex {
  final int index;
  final UserAchievementCollection collection;

  _ItemWithOrderIndex(this.index, this.collection);
}
