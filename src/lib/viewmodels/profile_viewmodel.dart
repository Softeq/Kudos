import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/helpers/disposable.dart';
import 'package:kudosapp/helpers/list_notifier.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/messages/achievement_sent_message.dart';
import 'package:kudosapp/models/selection_action.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_achievement_model.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/pages/achievements/achievements_page.dart';
import 'package:kudosapp/pages/teams/manage_team_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/services/teams_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class ProfileViewModel extends BaseViewModel with Disposable {
  final _eventBus = locator<EventBus>();
  final _authService = locator<BaseAuthService>();
  final _teamsService = locator<TeamsService>();
  final _peopleService = locator<PeopleService>();
  final _dialogsService = locator<DialogService>();
  final _achievementsService = locator<AchievementsService>();

  final UserModel user;
  final userTeams = new ListNotifier<TeamModel>();

  String get imageUrl => user.imageUrl;
  String get userName => user.name ?? "";
  bool get showSendButton =>
      user != null && user.id != _authService.currentUser.id;

  ProfileViewModel(this.user) {
    _initialize();
  }

  void _initialize() async {
    final loadedUser = await _peopleService.getUserById(user.id);
    user.updateWithModel(loadedUser);

    final teams = await _teamsService.getTeams(user.id);
    userTeams.replace(teams);

    notifyListeners();
  }

  Future<void> sendAchievement(BuildContext context) async {
    // Select achievement
    var achievement = await Navigator.of(context).push(
      AchievementsPageRoute(
        selectionAction: SelectionAction.Pop,
        showAddButton: false,
        selectorIcon: KudosTheme.sendSelectorIcon,
        achievementsFilter: (achievement) =>
            achievement.canBeSentByUser(_authService.currentUser.id),
      ),
    );
    if (achievement == null) {
      return;
    }

    // Add comment
    var comment = await _dialogsService.showCommentDialog(context: context);
    if (comment == null) {
      return;
    }

    // Send selected achievement to user with comment
    try {
      isBusy = true;

      var userAchievement = UserAchievementModel.createNew(
        _authService.currentUser,
        achievement,
        comment,
      );

      await _achievementsService.sendAchievement(user, userAchievement);

      _eventBus.fire(AchievementSentMessage(user, userAchievement));
    } finally {
      isBusy = false;
    }
  }

  void openTeamDetails(BuildContext context, TeamModel team) {
    if (!team.canBeViewedByUser(_authService.currentUser.id)) {
      _dialogsService.showOkDialog(
        context: context,
        title: localizer().accessDenied,
        content: localizer().privateTeam,
      );
    } else {
      Navigator.of(context).push(ManageTeamRoute(team));
    }
  }
}
