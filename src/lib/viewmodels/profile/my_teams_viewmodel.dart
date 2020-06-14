import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/models/messages/team_updated_message.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/database/teams_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class MyTeamsViewModel extends BaseViewModel {
  final items = List<Team>();

  final _teamsService = locator<TeamsService>();
  final _eventBus = locator<EventBus>();

  StreamSubscription _streamSubscription;

  MyTeamsViewModel() {
    isBusy = true;
  }

  Future<void> initialize() async {
    isBusy = true;

    var teams = await _teamsService.getTeams();

    items.clear();
    items.addAll(teams);

    isBusy = false;

    _streamSubscription?.cancel();
    _streamSubscription =
        _eventBus.on<TeamUpdatedMessage>().listen(_onTeamUpdated);
  }

  Future<Team> loadTeam(String id) {
    return _teamsService.getTeam(id);
  }

  void _onTeamUpdated(TeamUpdatedMessage x) {
    initialize();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
