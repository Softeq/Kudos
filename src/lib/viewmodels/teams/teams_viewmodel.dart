import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/models/grouped_list_item.dart';
import 'package:kudosapp/models/messages/team_deleted_message.dart';
import 'package:kudosapp/models/messages/team_updated_message.dart';
import 'package:kudosapp/models/selection_action.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/data_services/teams_service.dart';
import 'package:kudosapp/services/navigation_service.dart';
import 'package:kudosapp/viewmodels/searchable_list_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/edit_team_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/team_details_viewmodel.dart';

class TeamsViewModel
    extends SearchableListViewModel<GroupedListItem<TeamModel>> {
  final _eventBus = locator<EventBus>();
  final _teamsService = locator<TeamsService>();
  final _authService = locator<BaseAuthService>();
  final _navigationService = locator<NavigationService>();

  final SelectionAction _selectionAction;
  final Set<String> _excludedTeamIds;

  final Icon selectorIcon;
  final bool showAddButton;

  StreamSubscription<TeamUpdatedMessage> _teamUpdatedSubscription;
  StreamSubscription<TeamDeletedMessage> _teamDeletedSubscription;

  TeamsViewModel(
    this._selectionAction,
    this.showAddButton, {
    Set<String> excludedTeamIds,
    this.selectorIcon,
  })  : _excludedTeamIds = excludedTeamIds,
        super(sortFunc: _sortFunc) {
    _initialize();
  }

  static int _sortFunc(
      GroupedListItem<TeamModel> x, GroupedListItem<TeamModel> y) {
    if (x.sortIndex == y.sortIndex) {
      return x.item.name.toLowerCase().compareTo(y.item.name.toLowerCase());
    } else {
      return x.sortIndex.compareTo(y.sortIndex);
    }
  }

  void createTeam() {
    _navigationService.navigateTo(
      EditTeamViewModel(),
    );
  }

  void onTeamClicked(BuildContext context, TeamModel team) async {
    switch (_selectionAction) {
      case SelectionAction.OpenDetails:
        await _navigationService.navigateTo(
          TeamDetailsViewModel(team),
        );
        break;
      case SelectionAction.Pop:
        _navigationService.pop(team);
        break;
    }
    clearFocus(context);
  }

  @override
  bool filter(GroupedListItem<TeamModel> item, String query) {
    return item.item.name.toLowerCase().contains(query.toLowerCase());
  }

  @override
  void dispose() {
    _teamUpdatedSubscription?.cancel();
    _teamDeletedSubscription?.cancel();
    super.dispose();
  }

  void _initialize() async {
    try {
      isBusy = true;

      await _loadTeamsList();

      _teamUpdatedSubscription?.cancel();
      _teamUpdatedSubscription =
          _eventBus.on<TeamUpdatedMessage>().listen(_onTeamUpdated);

      _teamDeletedSubscription?.cancel();
      _teamDeletedSubscription =
          _eventBus.on<TeamDeletedMessage>().listen(_onTeamDeleted);
    } finally {
      filterByName("");
      isBusy = false;
    }
  }

  Future<void> _loadTeamsList() async {
    final teams = await _teamsService.getTeams();
    dataList.clear();
    dataList.addAll(
      teams.where(_isTeamVisible).map(_createGroupedItemFromTeam),
    );
  }

  GroupedListItem<TeamModel> _createGroupedItemFromTeam(TeamModel team) {
    final userId = _authService.currentUser.id;

    _teamType teamType;
    if (team.isOfficialTeam) {
      teamType = _teamType.official;
    } else if (team.isTeamAdmin(userId) || team.isTeamMember(userId)) {
      teamType = _teamType.myTeam;
    } else {
      teamType = _teamType.other;
    }

    String groupName;
    switch (teamType) {
      case _teamType.official:
        groupName = localizer().official;
        break;
      case _teamType.myTeam:
        groupName = localizer().myTeams;
        break;
      case _teamType.other:
        groupName = localizer().otherTeams;
        break;
    }

    return GroupedListItem<TeamModel>(groupName, teamType.index, team);
  }

  void _onTeamUpdated(TeamUpdatedMessage event) {
    _initialize();
  }

  void _onTeamDeleted(TeamDeletedMessage event) {
    dataList.removeWhere((x) => x.item.id == event.teamId);
    notifyListeners();
  }

  bool _isTeamVisible(TeamModel team) {
    if (_excludedTeamIds == null) {
      return true;
    } else {
      return !_excludedTeamIds.contains(team.id);
    }
  }
}

enum _teamType { official, myTeam, other }
