import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/helpers/list_notifier.dart';
import 'package:kudosapp/models/messages/achievement_deleted_message.dart';
import 'package:kudosapp/models/messages/achievement_transferred_message.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/models/messages/team_deleted_message.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/pages/achievements/edit_achievement_page.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/user_picker_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/database/achievements_service.dart';
import 'package:kudosapp/services/database/teams_service.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class ManageTeamViewModel extends BaseViewModel {
  final _eventBus = locator<EventBus>();
  final _teamsService = locator<TeamsService>();
  final _dialogService = locator<DialogService>();
  final _achievementsService = locator<AchievementsService>();

  final TeamModel _team;
  bool _canEdit;

  List<AchievementModel> achievements;
  ListNotifier<UserModel> members;
  ListNotifier<UserModel> admins;

  StreamSubscription _achievementUpdatedSubscription;
  StreamSubscription _achievementDeletedSubscription;
  StreamSubscription _achievementTransferredSubscription;

  String get name => _team.name;
  String get description => _team.description;
  String get imageUrl => _team.imageUrl;
  String get owners => admins.items.map((x) => x.name).join(", ");

  bool get canEdit => _team.owners == null
      ? false
      : _canEdit ??
          (_canEdit = _teamsService.canBeModifiedByCurrentUser(_team));

  ManageTeamViewModel(this._team) {
    _initialize();
  }

  void _initialize() async {
    isBusy = true;

    final loadedTeam = await _teamsService.getTeam(_team.id);
    _team.updateWithModel(loadedTeam);
    members = new ListNotifier<UserModel>.wrap(loadedTeam.members);
    admins = new ListNotifier<UserModel>.wrap(_team.owners);

    achievements = await _achievementsService.getTeamAchievements(_team.id) ??
        new List<AchievementModel>();

    _achievementUpdatedSubscription?.cancel();
    _achievementUpdatedSubscription =
        _eventBus.on<AchievementUpdatedMessage>().listen(_onAchievementUpdated);

    _achievementDeletedSubscription?.cancel();
    _achievementDeletedSubscription =
        _eventBus.on<AchievementDeletedMessage>().listen(_onAchievementDeleted);

    _achievementTransferredSubscription?.cancel();
    _achievementTransferredSubscription = _eventBus
        .on<AchievementTransferredMessage>()
        .listen(_onAchievementTransferred);

    isBusy = false;
  }

  void editAdmins(BuildContext context) async {
    if (!canEdit) {
      return;
    }

    var users = await Navigator.of(context).push(
      UserPickerRoute(
        allowMultipleSelection: true,
        allowCurrentUser: true,
        allowEmptyResult: false,
        searchHint: localizer().searchAdmins,
        selectedUserIds: admins.items.map((x) => x.id).toList(),
      ),
    );
    _replaceAdmins(users);
  }

  void editMembers(BuildContext context) async {
    if (!canEdit) {
      return;
    }

    var users = await Navigator.of(context).push(
      UserPickerRoute(
        allowMultipleSelection: true,
        allowCurrentUser: true,
        searchHint: localizer().searchMembers,
        selectedUserIds: members.items.map((x) => x.id).toList(),
      ),
    );
    _replaceMembers(users);
  }

  void editTeam(BuildContext context) async {
    await Navigator.of(context).push(EditTeamRoute(_team));
    notifyListeners();
  }

  void createAchievement(BuildContext context) {
    Navigator.of(context)
        .push(EditAchievementRoute.createTeamAchievement(_team));
  }

  void deleteTeam(BuildContext context) async {
    if (await _dialogService.showDeleteCancelDialog(
        context: context,
        title: localizer().warning,
        content: localizer().deleteTeamWarning)) {
      isBusy = true;

      await _teamsService.deleteTeam(_team, achievements);

      isBusy = false;
      _eventBus.fire(TeamDeletedMessage(_team.id));
      _eventBus.fire(AchievementDeletedMessage.multiple(
          achievements.map((x) => x.id).toSet()));
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }

  void _replaceMembers(Iterable<UserModel> users) {
    if (users == null) {
      return;
    }

    members.replace(users);

    _teamsService.updateTeamMembers(
      teamId: _team.id,
      newMembers: users,
      newAdmins: admins.items,
    );
  }

  void _replaceAdmins(Iterable<UserModel> users) {
    if (users == null || users.isEmpty) {
      return;
    }

    admins.replace(users);

    _teamsService.updateTeamMembers(
      teamId: _team.id,
      newMembers: members.items,
      newAdmins: users,
    );
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
    members.dispose();
    admins.dispose();
    _achievementUpdatedSubscription?.cancel();
    _achievementDeletedSubscription?.cancel();
    _achievementTransferredSubscription?.cancel();
    super.dispose();
  }
}
