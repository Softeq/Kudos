import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/dto/achievement.dart';
import 'package:kudosapp/dto/achievement_holder.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/achievement_to_send.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/models/messages/achievement_deleted_message.dart';
import 'package:kudosapp/models/messages/achievement_transferred_message.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/pages/people_page.dart';
import 'package:kudosapp/pages/teams/teams_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/database/achievements_service.dart';
import 'package:kudosapp/services/database/people_service.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';
import 'package:sprintf/sprintf.dart';

enum OwnerType { user, team }

class AchievementDetailsViewModel extends BaseViewModel {
  final _achievementsService = locator<AchievementsService>();
  final _peopleService = locator<PeopleService>();
  final _eventBus = locator<EventBus>();
  final _authService = locator<BaseAuthService>();
  final _dialogsService = locator<DialogService>();
  final String _achievementId;
  final String _imageUrl;

  StreamSubscription<AchievementUpdatedMessage> _subscription;
  Achievement _achievement;
  double _statisticsValue = 0;
  String _ownerName = "";
  String _ownerId = "";
  OwnerType _ownerType;

  final achievementHolders = new ListNotifier<AchievementHolder>();

  Achievement get achievement => _achievement;

  double get statisticsValue => _statisticsValue;

  String get ownerName => _ownerName;
  String get ownerId => _ownerId;
  OwnerType get ownerType => _ownerType;

  bool get canEdit => achievement?.canBeModifiedByCurrentUser ?? false;
  bool get canSend => achievement?.canBeSentByCurrentUser ?? false;

  AchievementDetailsViewModel(this._achievementId, this._imageUrl) {
    isBusy = true;
  }

  Future<void> initialize() async {
    isBusy = true;

    _achievement = await _achievementsService.getAchievement(_achievementId);
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
      achievement: achievement,
      comment: comment,
    );

    await _achievementsService.sendAchievement(achievementToSend);
    await initialize();

    isBusy = false;
  }

  Future<void> transferAchievement(BuildContext context) async {
    var result = await _dialogsService.showThreeButtonsDialog(
        context: context,
        title: localizer().transferAchievementTitle,
        content: localizer().transferAchievementDescription,
        firstButtonTitle: localizer().user,
        secondButtonTitle: localizer().team,
        thirdButtonTitle: localizer().cancel);

    switch (result) {
      case 1:
        {
          var excludedUserId = _achievement.userReference?.id;
          Navigator.of(context).push(PeoplePageRoute(
              excludedUserIds: excludedUserId == null ? null : {excludedUserId},
              selectorIcon: Icon(Icons.transfer_within_a_station,
                  size: 24.0, color: KudosTheme.accentColor),
              onItemSelected: _onUserSelected));
          break;
        }
      case 2:
        {
          var excludedTeamId = _achievement.teamReference?.id;
          Navigator.of(context).push(TeamsPageRoute(
            excludedTeamIds: excludedTeamId == null ? null : {excludedTeamId},
            selectorIcon: Icon(Icons.transfer_within_a_station,
                size: 24.0, color: KudosTheme.accentColor),
            onItemSelected: _onTeamSelected,
            showAddButton: false,
          ));
          break;
        }
    }
  }

  Future<void> _onUserSelected(BuildContext context, User user) async {
    if (await _dialogsService.showOkCancelDialog(
      context: context,
      title: sprintf(localizer().transferAchievementToUserTitle, [user.name]),
      content: localizer().transferAchievementToUserWarning,
    )) {
      var updatedAchievement = await _achievementsService.transferAchievement(
        id: achievement.id,
        user: user,
      );

      Navigator.popUntil(context, ModalRoute.withName('/'));
      _eventBus.fire(AchievementTransferredMessage.single(updatedAchievement));
    }
  }

  Future<void> _onTeamSelected(
      BuildContext context, Team team) async {
    if (await _dialogsService.showOkCancelDialog(
      context: context,
      title: sprintf(
          localizer().transferAchievementToTeamTitle, [team.name]),
      content: localizer().transferAchievementToTeamWarning,
    )) {
      var updatedAchievement = await _achievementsService.transferAchievement(
        id: achievement.id,
        team: team,
      );

      Navigator.popUntil(context, ModalRoute.withName('/'));
      _eventBus.fire(AchievementTransferredMessage.single(updatedAchievement));
    }
  }

  Future<void> deleteAchievement(BuildContext context) async {
    if (await _dialogsService.showDeleteCancelDialog(
        context: context,
        title: localizer().warning,
        content: localizer().deleteAchievementWarning)) {
      isBusy = true;

      await _achievementsService.deleteAchievement(
        achievement.id,
        holdersCount: achievementHolders.length,
      );

      isBusy = false;
      _eventBus.fire(AchievementDeletedMessage.single(achievement.id));
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _loadOwnerInfo() async {
    if (_achievement.teamReference != null) {
      _ownerName = _achievement.teamReference.name;
      _ownerId = _achievement.teamReference.id;
      _ownerType = OwnerType.team;
    } else {
      _ownerName = _achievement.userReference.name;
      _ownerId = _achievement.userReference.id;
      _ownerType = OwnerType.user;
    }
  }

  Future<void> _loadStatistics() async {
    // Number of users with this badge divided by the total number of users
    achievementHolders.replace(
        await _achievementsService.getAchievementHolders(achievement.id));

    var allUsersCount = await _peopleService.getUsersCount();
    _statisticsValue =
        allUsersCount == 0 ? 0 : achievementHolders.length / allUsersCount;
  }

  void _onAchievementUpdated(AchievementUpdatedMessage event) {
    if (event.achievement.id != achievement.id) {
      return;
    }

    _achievement = event.achievement;
    notifyListeners();
  }
}
