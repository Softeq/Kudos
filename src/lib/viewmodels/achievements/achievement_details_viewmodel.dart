import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/achievement_owner_model.dart';
import 'package:kudosapp/helpers/list_notifier.dart';
import 'package:kudosapp/models/messages/achievement_deleted_message.dart';
import 'package:kudosapp/models/messages/achievement_transferred_message.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/models/statistics_model.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/pages/people_page.dart';
import 'package:kudosapp/pages/teams/teams_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/database/achievements_service.dart';
import 'package:kudosapp/services/database/people_service.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:sprintf/sprintf.dart';

class AchievementDetailsViewModel extends BaseViewModel {
  final _eventBus = locator<EventBus>();
  final _peopleService = locator<PeopleService>();
  final _authService = locator<BaseAuthService>();
  final _dialogsService = locator<DialogService>();
  final _achievementsService = locator<AchievementsService>();

  StreamSubscription<AchievementUpdatedMessage> _subscription;

  final AchievementModel achievement;
  final achievementHolders = new ListNotifier<UserModel>();
  final allUsersStatistics = StatisticsModel.empty(localizer().softeq);

  AchievementDetailsViewModel(this.achievement) {
    _initialize();
  }

  void _initialize() async {
    isBusy = true;

    var loadedAchievement =
        await _achievementsService.getAchievement(achievement.id);
    achievement.updateWithModel(loadedAchievement);

    _subscription?.cancel();
    _subscription =
        _eventBus.on<AchievementUpdatedMessage>().listen(_onAchievementUpdated);

    // TODO YP: move to separate widgets
    await _loadStatistics();

    isBusy = false;
  }

  Future<void> sendTo(UserModel recipient, String comment) async {
    isBusy = true;

    await _achievementsService.sendAchievement(recipient, achievement, comment);

    // TODO: fix
    await _loadStatistics();

    isBusy = false;
  }

  Future<void> transferAchievement(BuildContext context) async {
    var result = await _dialogsService.showThreeButtonsDialog(
      context: context,
      title: localizer().transferAchievementTitle,
      content: localizer().transferAchievementDescription,
      firstButtonTitle: localizer().user,
      secondButtonTitle: localizer().team,
      thirdButtonTitle: localizer().cancel,
    );

    switch (result) {
      case 1:
        {
          var excludedUserId =
              achievement.owner.type == AchievementOwnerType.user
                  ? achievement.owner.id
                  : null;
          Navigator.of(context).push(PeoplePageRoute(
              excludedUserIds: excludedUserId == null ? null : {excludedUserId},
              selectorIcon: Icon(Icons.transfer_within_a_station,
                  size: 24.0, color: KudosTheme.accentColor),
              onItemSelected: _onUserSelected));
          break;
        }
      case 2:
        {
          var excludedTeamId =
              achievement.owner.type == AchievementOwnerType.team
                  ? achievement.owner.id
                  : null;
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

  Future<void> _onUserSelected(BuildContext context, UserModel user) async {
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

  Future<void> _onTeamSelected(BuildContext context, TeamModel team) async {
    if (await _dialogsService.showOkCancelDialog(
      context: context,
      title: sprintf(localizer().transferAchievementToTeamTitle, [team.name]),
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

  Future<void> _loadStatistics() async {
    // Number of users with this badge divided by the total number of users
    achievementHolders.replace(
        await _achievementsService.getAchievementHolders(achievement.id));

    var allUsersCount = await _peopleService.getUsersCount();
    allUsersStatistics.allUsersCount = allUsersCount;
    allUsersStatistics.positiveUsersCount = achievementHolders.length;
  }

  void _onAchievementUpdated(AchievementUpdatedMessage event) {
    if (event.achievement.id != achievement.id) {
      return;
    }

    achievement.updateWithModel(event.achievement);
    notifyListeners();
  }
}
