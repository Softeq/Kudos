import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/models/messages/team_deleted_message.dart';
import 'package:kudosapp/models/messages/team_updated_message.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/database/teams_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class MyTeamsViewModel extends BaseViewModel {
  final items = List<TeamModel>();
  final Set<String> _excludedTeamIds;

  final _teamsService = locator<TeamsService>();
  final _eventBus = locator<EventBus>();

  StreamSubscription _teamUpdatedSubscription;
  StreamSubscription _teamDeletedSubscription;

  MyTeamsViewModel({Set<String> excludedTeamIds})
      : _excludedTeamIds = excludedTeamIds {
    isBusy = true;
  }

  Future<void> initialize() async {
    isBusy = true;

    await _loadTeamsList();

    isBusy = false;

    _teamUpdatedSubscription?.cancel();
    _teamUpdatedSubscription =
        _eventBus.on<TeamUpdatedMessage>().listen(_onTeamUpdated);

    _teamDeletedSubscription?.cancel();
    _teamDeletedSubscription =
        _eventBus.on<TeamDeletedMessage>().listen(_onTeamDeleted);
  }

  Future<void> _loadTeamsList() async {
    var teams = await _teamsService.getTeams();

    items.forEach((x) {
      x.dispose();
    });
    items.clear();
    if (_excludedTeamIds != null)
    {
      var localTeams = teams.where((team) => !_excludedTeamIds.contains(team.id));
      items.addAll(localTeams.map((x) => TeamModel(x)));
    }
    else
    {
      items.addAll(teams.map((x) => TeamModel(x)));
    }
  }

  Future<Team> loadTeam(String id) {
    return _teamsService.getTeam(id);
  }

  void _onTeamUpdated(TeamUpdatedMessage event) {
    initialize();
  }

  void _onTeamDeleted(TeamDeletedMessage event) {
    items.removeWhere((teamModel) => teamModel.team.id == event.teamId);
    notifyListeners();
  }

  @override
  void dispose() {
    _teamUpdatedSubscription?.cancel();
    _teamDeletedSubscription?.cancel();

    items.forEach((x) {
      x.dispose();
    });
    super.dispose();
  }
}
