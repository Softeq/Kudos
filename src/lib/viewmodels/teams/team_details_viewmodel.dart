import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/models/access_level.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/messages/achievement_deleted_message.dart';
import 'package:kudosapp/models/messages/achievement_transferred_message.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/models/messages/team_deleted_message.dart';
import 'package:kudosapp/models/team_member_model.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/analytics_service.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/data_services/achievements_service.dart';
import 'package:kudosapp/services/data_services/teams_service.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/services/navigation_service.dart';
import 'package:kudosapp/viewmodels/achievements/achievement_details_viewmodel.dart';
import 'package:kudosapp/viewmodels/achievements/edit_achievement_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/edit_team_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/team_member_picker_viewmodel.dart';
import 'package:kudosapp/viewmodels/users/user_details_viewmodel.dart';

class TeamDetailsViewModel extends BaseViewModel {
  final _eventBus = locator<EventBus>();
  final _teamsService = locator<TeamsService>();
  final _authService = locator<BaseAuthService>();
  final _dialogService = locator<DialogService>();
  final _analyticsService = locator<AnalyticsService>();
  final _navigationService = locator<NavigationService>();
  final _achievementsService = locator<AchievementsService>();

  final TeamModel _team;

  final achievements = List<AchievementModel>();

  StreamSubscription _achievementUpdatedSubscription;
  StreamSubscription _achievementDeletedSubscription;
  StreamSubscription _achievementTransferredSubscription;

  String get name => _team.name;

  String get description => _team.description;

  String get imageUrl => _team.imageUrl;

  AccessLevel get accessLevel => _team.accessLevel;

  Iterable<TeamMemberModel> get members => _team.members.values;

  bool get canEdit =>
      _team.members == null
          ? false
          : _team.canBeModifiedByUser(_authService.currentUser.id);

  TeamDetailsViewModel(this._team) {
    _initialize();
  }

  void _initialize() async {
    try {
      isBusy = true;

      final loadedTeam = await _teamsService.getTeam(_team.id);
      _team.updateWithModel(loadedTeam);

      achievements
          .addAll(await _achievementsService.getTeamAchievements(_team.id));

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

  void editMembers(BuildContext context) async {
    if (!canEdit) {
      return;
    }

    await _navigationService
        .navigateTo(
      context,
      TeamMemberPickerViewModel(_team),
      fullscreenDialog: true,
    )
        .whenComplete(notifyListeners);

    notifyListeners();
  }

  void editTeam(BuildContext context) {
    _navigationService
        .navigateTo(context, EditTeamViewModel(_team))
        .whenComplete(notifyListeners);
  }

  void openTeamMemberDetails(BuildContext context, TeamMemberModel teamMember) {
    _navigationService.navigateTo(
      context,
      UserDetailsViewModel(teamMember.user),
    );
  }

  void openAchievementDetails(BuildContext context,
      AchievementModel achievement,) {
    _navigationService.navigateTo(
      context,
      AchievementDetailsViewModel(achievement),
    );
  }

  void createAchievement(BuildContext context) {
    _navigationService.navigateTo(
      context,
      EditAchievementViewModel.createTeamAchievement(_team),
    );
  }

  void deleteTeam(BuildContext context) async {
    if (await _dialogService.showDeleteCancelDialog(
        context: context,
        title: localizer().warning,
        content: localizer().deleteTeamWarning)) {
      try {
        isBusy = true;

        await _teamsService.deleteTeam(_team);

        _analyticsService.logTeamDeleted();
        _eventBus.fire(TeamDeletedMessage(_team.id));
        _eventBus.fire(
          AchievementDeletedMessage.multiple(
            achievements.map((x) => x.id).toSet(),
          ),
        );
        Navigator.popUntil(context, ModalRoute.withName('/'));
      } finally {
        isBusy = false;
      }
    }
  }

  void _onAchievementUpdated(AchievementUpdatedMessage event) {
    if (event.achievement.owner.id != _team.id) {
      return;
    }

    final index = achievements.indexWhere(
          (x) => x.id == event.achievement.id,
    );
    if (index != -1) {
      achievements.removeAt(index);
      achievements.insert(index, event.achievement);
    } else {
      achievements.add(event.achievement);
    }
    notifyListeners();
  }

  void _onAchievementDeleted(AchievementDeletedMessage event) {
    achievements.removeWhere((x) => event.ids.contains(x.id));
    notifyListeners();
  }

  void _onAchievementTransferred(AchievementTransferredMessage event) {
    if (event.achievements.first.owner.id != _team.id) {
      var achievementIds = event.achievements.map((a) => a.id).toSet();
      achievements.removeWhere((x) => achievementIds.contains(x.id));
    } else {
      var achievementIds = achievements.map((x) => x.id).toSet();
      for (var achievement in event.achievements) {
        if (!achievementIds.contains(achievement.id)) {
          achievements.add(achievement);
        }
      }
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _achievementUpdatedSubscription?.cancel();
    _achievementDeletedSubscription?.cancel();
    _achievementTransferredSubscription?.cancel();
    super.dispose();
  }
}
