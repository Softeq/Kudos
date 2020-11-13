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
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/data_services/achievements_service.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/services/data_services/users_service.dart';
import 'package:kudosapp/services/data_services/teams_service.dart';
import 'package:kudosapp/services/navigation_service.dart';
import 'package:kudosapp/viewmodels/achievements/achievements_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/team_details_viewmodel.dart';

class UserDetailsViewModel extends BaseViewModel with Disposable {
  final _eventBus = locator<EventBus>();
  final _teamsService = locator<TeamsService>();
  final _peopleService = locator<UsersService>();
  final _authService = locator<BaseAuthService>();
  final _dialogsService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  final _achievementsService = locator<AchievementsService>();

  final UserModel user;
  final userTeams = new ListNotifier<TeamModel>();

  String get imageUrl => user.imageUrl;
  String get userName => user.name ?? "";
  bool get showSendButton =>
      user != null && user.id != _authService.currentUser.id;

  UserDetailsViewModel(this.user) {
    _initialize();
  }

  void _initialize() async {
    try {
      isBusy = true;
      final loadedUser = await _peopleService.getUser(user.id);
      user.updateWithModel(loadedUser);

      final teams = await _teamsService.getUserTeams(user.id);
      userTeams.replace(teams);
    } finally {
      isBusy = false;
    }
  }

  Future<void> sendAchievement(BuildContext context) async {
    // Select achievement
    var achievement = await _navigationService.navigateTo(
      AchievementsViewModel(
        SelectionAction.Pop,
        false,
        selectorIcon: KudosTheme.sendSelectorIcon,
        achievementsFilter: (achievement) =>
            achievement.canBeSentToUser(_authService.currentUser.id, user.id),
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
      _navigationService.navigateTo(
        TeamDetailsViewModel(team),
      );
    }
  }
}
