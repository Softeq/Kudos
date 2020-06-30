import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/dto/achievement_holder.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/achievement_to_send.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/models/messages/achievement_deleted_message.dart';
import 'package:kudosapp/models/messages/achievement_transferred_message.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/models/team_model.dart';
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
  final ImageViewModel _imageViewModel;

  StreamSubscription<AchievementUpdatedMessage> _subscription;
  AchievementModel _achievementModel;
  double _statisticsValue = 0;
  String _ownerName = "";
  String _ownerId = "";
  OwnerType _ownerType;

  final achievementHolders = new ListNotifier<AchievementHolder>();

  AchievementModel get achievementModel => _achievementModel;
  ImageViewModel get imageViewModel => _imageViewModel;

  double get statisticsValue => _statisticsValue;

  String get ownerName => _ownerName;
  String get ownerId => _ownerId;
  OwnerType get ownerType => _ownerType;

  bool get canEdit => achievementModel?.achievement?.canBeModifiedByCurrentUser ?? false;
  bool get canSend => achievementModel?.achievement?.canBeSentByCurrentUser ?? false;

  AchievementDetailsViewModel(this._achievementId, this._imageViewModel) {
    isBusy = true;
  }

  Future<void> initialize() async {
    isBusy = true;

    final achievement =
        await _achievementsService.getAchievement(_achievementId);

    _achievementModel = AchievementModel(achievement);
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
      achievement: achievementModel.achievement,
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
          var excludedUserId = achievementModel.user?.id;
          Navigator.of(context).push(PeoplePageRoute(
              excludedUserIds: excludedUserId == null ? null : {excludedUserId},
              selectorIcon: Icon(Icons.transfer_within_a_station,
                  size: 24.0, color: KudosTheme.accentColor),
              onItemSelected: _onUserSelected));
          break;
        }
      case 2:
        {
          var excludedTeamId = achievementModel.team?.id;
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
          id: achievementModel.achievement.id, user: user);

      Navigator.popUntil(context, ModalRoute.withName('/'));
      _eventBus.fire(AchievementTransferredMessage.single(updatedAchievement));
    }
  }

  Future<void> _onTeamSelected(BuildContext context, TeamModel teamModel) async {
    if (await _dialogsService.showOkCancelDialog(
      context: context,
      title: sprintf(localizer().transferAchievementToTeamTitle, [teamModel.team.name]),
      content: localizer().transferAchievementToTeamWarning,
    )) {
      var updatedAchievement = await _achievementsService.transferAchievement(
          id: achievementModel.achievement.id, team: teamModel.team);

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
          achievementModel.achievement.id,
          holdersCount: achievementHolders.length);

      isBusy = false;
      _eventBus.fire(
          AchievementDeletedMessage.single(achievementModel.achievement.id));
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }

  @override
  void dispose() {
    _achievementModel.dispose();
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _loadOwnerInfo() async {
    if (_achievementModel.team != null) {
      _ownerName = _achievementModel.team.name;
      _ownerId = _achievementModel.team.id;
      _ownerType = OwnerType.team;
    } else {
      _ownerName = _achievementModel.user.name;
      _ownerId = _achievementModel.user.id;
      _ownerType = OwnerType.user;
    }
  }

  Future<void> _loadStatistics() async {
    // Number of users with this badge divided by the total number of users
    achievementHolders.replace(await _achievementsService
        .getAchievementHolders(achievementModel.achievement.id));

    var allUsersCount = await _peopleService.getUsersCount();
    _statisticsValue = allUsersCount == 0
        ? 0
        : achievementHolders.length / allUsersCount;
  }

  void _onAchievementUpdated(AchievementUpdatedMessage event) {
    if (event.achievement.id != _achievementModel.achievement.id) {
      return;
    }

    _achievementModel.initialize(event.achievement);
    notifyListeners();
  }
}
