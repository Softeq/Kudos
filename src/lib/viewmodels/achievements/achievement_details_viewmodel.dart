import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/achievement_owner_model.dart';
import 'package:kudosapp/helpers/list_notifier.dart';
import 'package:kudosapp/models/messages/achievement_deleted_message.dart';
import 'package:kudosapp/models/messages/achievement_sent_message.dart';
import 'package:kudosapp/models/messages/achievement_transferred_message.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/models/selection_action.dart';
import 'package:kudosapp/models/statistics_model.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_achievement_model.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/pages/people_page.dart';
import 'package:kudosapp/pages/profile_page.dart';
import 'package:kudosapp/pages/teams/manage_team_page.dart';
import 'package:kudosapp/pages/teams/teams_page.dart';
import 'package:kudosapp/pages/user_picker_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/services/teams_service.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:sprintf/sprintf.dart';

class AchievementDetailsViewModel extends BaseViewModel {
  final _eventBus = locator<EventBus>();
  final _authService = locator<BaseAuthService>();
  final _peopleService = locator<PeopleService>();
  final _teamsService = locator<TeamsService>();
  final _dialogsService = locator<DialogService>();
  final _achievementsService = locator<AchievementsService>();

  StreamSubscription<AchievementUpdatedMessage> _achievementUpdatedSubscription;
  StreamSubscription<AchievementSentMessage> _achievementReceivedSubscription;

  final AchievementModel achievement;
  final achievementHolders = new ListNotifier<UserModel>();
  final allUsersStatistics = StatisticsModel.empty(localizer().softeq);

  StatisticsModel _teamUsersStatistics;
  StatisticsModel get teamUsersStatistics => _teamUsersStatistics;

  AchievementDetailsViewModel(this.achievement) {
    _initialize();
  }

  void _initialize() async {
    try {
      isBusy = true;

      var loadedAchievement =
          await _achievementsService.getAchievement(achievement.id);
      achievement.updateWithModel(loadedAchievement);

      _achievementReceivedSubscription?.cancel();
      _achievementReceivedSubscription =
          _eventBus.on<AchievementSentMessage>().listen(_onAchievementReceived);

      _achievementUpdatedSubscription?.cancel();
      _achievementUpdatedSubscription = _eventBus
          .on<AchievementUpdatedMessage>()
          .listen(_onAchievementUpdated);

      // TODO YP: move to separate widgets
      await _loadStatistics();
    } finally {
      isBusy = false;
    }
  }

  bool canEdit() =>
      achievement.canBeModifiedByUser(_authService.currentUser.id);
  bool canSend() => achievement.canBeSentByUser(_authService.currentUser.id);

  Future<void> sendAchievement(BuildContext context) async {
    // Pick user
    var selectedUsers = await Navigator.of(context).push(
      UserPickerRoute(
        allowMultipleSelection: false,
        allowCurrentUser: false,
        trailingBuilder: (context) {
          return KudosTheme.sendSelectorIcon;
        },
      ),
    );

    if (selectedUsers == null || selectedUsers.isEmpty) {
      return;
    }

    // Add comment
    var comment = await _dialogsService.showCommentDialog(context: context);
    if (comment == null) {
      return;
    }

    // Send achievement to selected user with comment
    try {
      isBusy = true;

      var userAchievement = UserAchievementModel.createNew(
        _authService.currentUser,
        achievement,
        comment,
      );

      await _achievementsService.sendAchievement(
        selectedUsers.first,
        userAchievement,
      );

      _eventBus
          .fire(AchievementSentMessage(selectedUsers.first, userAchievement));
    } finally {
      isBusy = false;
    }
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
          var excludedUserIds =
              achievement.owner.type == AchievementOwnerType.user
                  ? {achievement.owner.id}
                  : null;
          var user = await Navigator.of(context).push(PeoplePageRoute(
            selectionAction: SelectionAction.Pop,
            excludedUserIds: excludedUserIds,
            selectorIcon: KudosTheme.transferSelectorIcon,
          ));
          _onUserSelected(context, user);
          break;
        }
      case 2:
        {
          var excludedTeamIds =
              achievement.owner.type == AchievementOwnerType.team
                  ? {achievement.owner.id}
                  : null;
          var team = await Navigator.of(context).push(TeamsPageRoute(
            selectionAction: SelectionAction.Pop,
            showAddButton: false,
            excludedTeamIds: excludedTeamIds,
            selectorIcon: KudosTheme.transferSelectorIcon,
          ));
          _onTeamSelected(context, team);
          break;
        }
    }
  }

  Future<void> _onUserSelected(BuildContext context, UserModel user) async {
    if (user == null) {
      return;
    }
    if (await _dialogsService.showOkCancelDialog(
      context: context,
      title: sprintf(localizer().transferAchievementToUserTitle, [user.name]),
      content: localizer().transferAchievementToUserWarning,
    )) {
      try {
        isBusy = true;
        var updatedAchievement = await _achievementsService.transferAchievement(
          achievement,
          AchievementOwnerModel.fromUser(user),
        );
        _eventBus
            .fire(AchievementTransferredMessage.single(updatedAchievement));
        Navigator.popUntil(context, ModalRoute.withName('/'));
      } finally {
        isBusy = false;
      }
    }
  }

  Future<void> _onTeamSelected(BuildContext context, TeamModel team) async {
    if (team == null) {
      return;
    }
    if (await _dialogsService.showOkCancelDialog(
      context: context,
      title: sprintf(localizer().transferAchievementToTeamTitle, [team.name]),
      content: localizer().transferAchievementToTeamWarning,
    )) {
      try {
        isBusy = true;
        var updatedAchievement = await _achievementsService.transferAchievement(
          achievement,
          AchievementOwnerModel.fromTeam(team),
        );
        _eventBus
            .fire(AchievementTransferredMessage.single(updatedAchievement));
        Navigator.popUntil(context, ModalRoute.withName('/'));
      } finally {
        isBusy = false;
      }
    }
  }

  Future<void> deleteAchievement(BuildContext context) async {
    var deletionConfirmed = await _dialogsService.showDeleteCancelDialog(
      context: context,
      title: localizer().warning,
      content: localizer().deleteAchievementWarning,
    );
    if (deletionConfirmed) {
      try {
        isBusy = true;

        await _achievementsService.deleteAchievement(
          achievement,
          holdersCount: achievementHolders.length,
        );
        _eventBus.fire(AchievementDeletedMessage.single(achievement.id));
        Navigator.popUntil(context, ModalRoute.withName('/'));
      } finally {
        isBusy = false;
      }
    }
  }

  void onOwnerClicked(BuildContext context) {
    switch (achievement.owner.type) {
      case AchievementOwnerType.user:
        Navigator.of(context)
            .push(ProfileRoute(achievement.owner.user))
            .whenComplete(() => notifyListeners());
        break;
      case AchievementOwnerType.team:
        Navigator.of(context)
            .push(ManageTeamRoute(achievement.owner.team))
            .whenComplete(() => notifyListeners());
        break;
    }
  }

  Future<void> _loadStatistics() async {
    achievementHolders.replace(
        await _achievementsService.getAchievementHolders(achievement.id));

    var allUsersCount = await _peopleService.getUsersCount();
    allUsersStatistics.allUsersCount = allUsersCount;
    allUsersStatistics.positiveUsersCount = achievementHolders.length;

    if (achievement.owner.type == AchievementOwnerType.team &&
        achievement.owner.name != localizer().softeq) {
      if (achievement.owner.team.members == null) {
        final loadedTeam =
            await _teamsService.getTeam(achievement.owner.team.id);
        achievement.owner.team.updateWithModel(loadedTeam);
      }
      var teamHolders = achievementHolders.items
          .where((x) => achievement.owner.team.members.containsKey(x.id));
      _teamUsersStatistics = StatisticsModel(
        achievement.owner.name,
        achievement.owner.team.members.length,
        teamHolders.length,
      );
    } else {
      _teamUsersStatistics = null;
    }
  }

  void _onAchievementUpdated(AchievementUpdatedMessage event) {
    if (event.achievement.id != achievement.id) {
      return;
    }

    achievement.updateWithModel(event.achievement);
    notifyListeners();
  }

  void _onAchievementReceived(AchievementSentMessage event) {
    if (event.userAchievement.achievement.id != achievement.id) {
      return;
    }

    if (!achievementHolders.items
        .any((user) => user.id == event.recipient.id)) {
      achievementHolders.add(event.recipient);

      allUsersStatistics.positiveUsersCount++;
      if (_teamUsersStatistics != null &&
          achievement.owner.team.members.containsKey(event.recipient.id)) {
        _teamUsersStatistics.positiveUsersCount++;
      }
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _achievementUpdatedSubscription.cancel();
    _achievementReceivedSubscription.cancel();
    super.dispose();
  }
}
