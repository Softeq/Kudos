import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kudosapp/dto/achievement_holder.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/achievement_to_send.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/database/achievements_service.dart';
import 'package:kudosapp/services/database/people_service.dart';
import 'package:kudosapp/services/dialogs_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

enum OwnerType { user, team }

class AchievementDetailsViewModel extends BaseViewModel {
  final _achievementsService = locator<AchievementsService>();
  final _peopleService = locator<PeopleService>();
  final _eventBus = locator<EventBus>();
  final _authService = locator<BaseAuthService>();
  final _dialogsService = locator<DialogsService>();
  final String _achievementId;

  StreamSubscription<AchievementUpdatedMessage> _subscription;
  AchievementModel _achievementViewModel;
  double _statisticsValue = 0;
  String _ownerName = "";
  String _ownerId = "";
  OwnerType _ownerType;

  final achievementHolders = new ListNotifier<AchievementHolder>();

  AchievementModel get achievementViewModel => _achievementViewModel;

  double get statisticsValue => _statisticsValue;

  String get ownerName => _ownerName;

  String get ownerId => _ownerId;

  OwnerType get ownerType => _ownerType;

  bool get canEdit =>
      achievementViewModel.achievement.canBeModifiedByCurrentUser;

  bool get canSend => achievementViewModel.achievement.canBeSentByCurrentUser;

  AchievementDetailsViewModel(this._achievementId) {
    isBusy = true;
  }

  Future<void> initialize() async {
    isBusy = true;

    final achievement =
        await _achievementsService.getAchievement(_achievementId);

    _achievementViewModel = AchievementModel(achievement);
    _subscription?.cancel();
    _subscription =
        _eventBus.on<AchievementUpdatedMessage>().listen(_onAchievementUpdated);

    // TODO YP: move to separate widgets
    await _loadStatistics();
    await _loadOwnerInfo();

    isBusy = false;
  }

  Future<void> sendTo(User recipient, String comment) async {
    isBusy = true;

    final achievementToSend = AchievementToSend(
      sender: _authService.currentUser,
      recipient: recipient,
      achievement: achievementViewModel.achievement,
      comment: comment,
    );

    await _achievementsService.sendAchievement(achievementToSend);
    await initialize();

    isBusy = false;
  }

  Future<void> deleteAchievement() async {
    if (await _dialogsService.showDeleteCancelDialog(
        title: localizer().warning,
        content: localizer().deleteAchievementWarning)) {
      isBusy = true;

      await _achievementsService.deleteAchievement(
          achievementViewModel.achievement.id,
          holdersCount: achievementHolders.items?.length ?? 0);

      isBusy = false;
      Navigator.popUntil(Get.context, ModalRoute.withName('/'));
    }
  }

  @override
  void dispose() {
    _achievementViewModel.dispose();
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _loadOwnerInfo() async {
    if (_achievementViewModel.team != null) {
      _ownerName = _achievementViewModel.team.name;
      _ownerId = _achievementViewModel.team.id;
      _ownerType = OwnerType.team;
    } else {
      _ownerName = _achievementViewModel.user.name;
      _ownerId = _achievementViewModel.user.id;
      _ownerType = OwnerType.user;
    }
  }

  Future<void> _loadStatistics() async {
    // Number of users with this badge divided by the total number of users
    achievementHolders.replace(await _achievementsService
        .getAchievementHolders(achievementViewModel.achievement.id));

    var allUsersCount = await _peopleService.getUsersCount();
    _statisticsValue = allUsersCount == 0
        ? 0
        : achievementHolders.items.length / allUsersCount;
  }

  void _onAchievementUpdated(AchievementUpdatedMessage event) {
    if (event.achievement.id != _achievementViewModel.achievement.id) {
      return;
    }

    _achievementViewModel.initialize(event.achievement);
    notifyListeners();
  }
}
