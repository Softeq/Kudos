import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/models/groupped_list_item.dart';
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
    extends SearchableListViewModel<GrouppedListItem<TeamModel>> {
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
      GrouppedListItem<TeamModel> x, GrouppedListItem<TeamModel> y) {
    if (x.sortIndex == y.sortIndex) {
      return x.item.name.toLowerCase().compareTo(y.item.name.toLowerCase());
    } else {
      return y.sortIndex.compareTo(x.sortIndex);
    }
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
    var teams = await _teamsService.getTeams();
    dataList.clear();
    if (_excludedTeamIds != null) {
      var localTeams = teams
          .where((team) => !_excludedTeamIds.contains(team.id))
          .map((tm) => _createGrouppedItemFromTeam(tm));
      dataList.addAll(localTeams);
    } else {
      dataList.addAll(teams.map((tm) => _createGrouppedItemFromTeam(tm)));
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

  GrouppedListItem<TeamModel> _createGrouppedItemFromTeam(TeamModel team) {
    int sortIndex = team.isTeamAdmin(_authService.currentUser.id) ||
            team.isTeamMember(_authService.currentUser.id)
        ? 1
        : 0;

    final myTeamsText = localizer().myTeams;
    final otherTeamsText = localizer().otherTeams;
    String groupName = sortIndex > 0 ? myTeamsText : otherTeamsText;

    return GrouppedListItem<TeamModel>(groupName, sortIndex, team);
  }

  void _onTeamUpdated(TeamUpdatedMessage event) {
    _initialize();
  }

  void _onTeamDeleted(TeamDeletedMessage event) {
    dataList.removeWhere((x) => x.item.id == event.teamId);
    notifyListeners();
  }

  @override
  bool filter(GrouppedListItem<TeamModel> item, String query) {
    return item.item.name.toLowerCase().contains(query.toLowerCase());
  }

  @override
  void dispose() {
    _teamUpdatedSubscription?.cancel();
    _teamDeletedSubscription?.cancel();
    super.dispose();
  }
}
