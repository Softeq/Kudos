import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/achievement_owner_model.dart';
import 'package:kudosapp/models/groupped_list_item.dart';
import 'package:kudosapp/models/messages/achievement_deleted_message.dart';
import 'package:kudosapp/models/messages/achievement_transferred_message.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/models/selection_action.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/data_services/achievements_service.dart';
import 'package:kudosapp/services/navigation_service.dart';
import 'package:kudosapp/viewmodels/achievements/achievement_details_viewmodel.dart';
import 'package:kudosapp/viewmodels/achievements/edit_achievement_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:sorted_list/sorted_list.dart';

class AchievementsViewModel extends BaseViewModel {
  final _eventBus = locator<EventBus>();
  final _authService = locator<BaseAuthService>();
  final _navigationService = locator<NavigationService>();
  final _achievementsService = locator<AchievementsService>();

  StreamSubscription _achievementUpdatedSubscription;
  StreamSubscription _achievementDeletedSubscription;
  StreamSubscription _achievementTransferredSubscription;

  final SelectionAction _selectionAction;
  final achievements =
      SortedList<GrouppedListItem<AchievementModel>>(_sortFunc);
  final bool Function(AchievementModel) _achievementFilter;

  final Icon selectorIcon;
  final bool showAddButton;

  AchievementsViewModel(
    this._selectionAction,
    this.showAddButton, {
    this.selectorIcon,
    bool Function(AchievementModel) achievementsFilter,
  }) : _achievementFilter = achievementsFilter {
    _initialize();
  }

  static int _sortFunc(
    GrouppedListItem<AchievementModel> x,
    GrouppedListItem<AchievementModel> y,
  ) {
    if (x.sortIndex == y.sortIndex) {
      return x.groupName.compareTo(y.groupName);
    } else {
      return y.sortIndex.compareTo(x.sortIndex);
    }
  }

  void _initialize() async {
    try {
      isBusy = true;

      final loadedAchievements = await _achievementsService.getAchievements();

      achievements.clear();
      achievements.addAll(loadedAchievements
          .where(
              _achievementFilter == null ? _defaultFilter : _achievementFilter)
          .map((a) => _createGrouppedItemFromAchievement(a)));
      notifyListeners();

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

  bool _defaultFilter(AchievementModel a) {
    if (a.owner.type == AchievementOwnerType.user) {
      return a.owner.id == _authService.currentUser.id;
    } else {
      return a.canBeViewedByUser(_authService.currentUser.id);
    }
  }

  void onAchievementClicked(
    AchievementModel achievement,
  ) {
    switch (_selectionAction) {
      case SelectionAction.OpenDetails:
        _navigationService
            .navigateTo(
              AchievementDetailsViewModel(achievement),
            )
            .whenComplete(notifyListeners);
        break;
      case SelectionAction.Pop:
        _navigationService.pop(achievement);
        break;
    }
  }

  void createAchievement() {
    _navigationService.navigateTo(
      EditAchievementViewModel.createUserAchievement(_authService.currentUser),
    );
  }

  void _onAchievementUpdated(AchievementUpdatedMessage event) {
    if (event.achievement.owner.type == AchievementOwnerType.user &&
        event.achievement.owner.id != _authService.currentUser.id) {
      return;
    }

    achievements.removeWhere((x) => x.item.id == event.achievement.id);
    achievements.add(_createGrouppedItemFromAchievement(event.achievement));
    notifyListeners();
  }

  void _onAchievementDeleted(AchievementDeletedMessage event) {
    achievements.removeWhere((x) => event.ids.contains(x.item.id));
    notifyListeners();
  }

  void _onAchievementTransferred(AchievementTransferredMessage event) {
    var achievementIds = event.achievements.map((a) => a.id).toSet();
    achievements.removeWhere((x) => achievementIds.contains(x.item.id));

    if (event.achievements.first.owner.type == AchievementOwnerType.team ||
        event.achievements.first.owner.id == _authService.currentUser.id) {
      for (var achievement in event.achievements) {
        achievements.add(_createGrouppedItemFromAchievement(achievement));
      }
    }

    notifyListeners();
  }

  GrouppedListItem<AchievementModel> _createGrouppedItemFromAchievement(
    AchievementModel achievement,
  ) {
    final sortIndex =
        (achievement.owner.id == _authService.currentUser.id) ? 1 : 0;
    final groupName =
        sortIndex > 0 ? localizer().myAchievements : achievement.owner.name;

    return GrouppedListItem<AchievementModel>(
      groupName,
      sortIndex,
      achievement,
    );
  }

  @override
  void dispose() {
    _achievementUpdatedSubscription?.cancel();
    _achievementDeletedSubscription?.cancel();
    _achievementTransferredSubscription?.cancel();

    super.dispose();
  }
}
