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
  final List<TeamModel> _teamsList = [];
  final Set<String> _excludedTeamIds;

  final _teamsService = locator<TeamsService>();
  final _eventBus = locator<EventBus>();

  StreamController<String> _streamController;
  Stream<List<TeamModel>> _teamsStream;

  StreamSubscription _teamUpdatedSubscription;
  StreamSubscription _teamDeletedSubscription;

  Stream<List<TeamModel>> get teamsStream => _teamsStream;

  MyTeamsViewModel({Set<String> excludedTeamIds})
      : _excludedTeamIds = excludedTeamIds {
    isBusy = false;
    _initFilter();
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

  void filterByName(String query) => _streamController.add(query);

  void _initFilter() {
    _streamController = StreamController<String>();

    _teamsStream = _streamController.stream
        // .debounceTime(Duration(milliseconds: 100))
        .distinct()
        .transform(StreamTransformer<String, List<TeamModel>>.fromHandlers(
          handleData: (query, sink) => sink.add(
              query.isEmpty ? _teamsList : _filterByName(_teamsList, query)),
        ));
  }

  List<TeamModel> _filterByName(List<TeamModel> teams, String query) {
    final filteredTeams = teams
        .where((teamModel) =>
            teamModel.team.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredTeams;
  }

  Future<void> _loadTeamsList() async {
    var teams = await _teamsService.getTeams();

    _teamsList.forEach((x) {
      x.dispose();
    });
    _teamsList.clear();
    if (_excludedTeamIds != null) {
      var localTeams =
          teams.where((team) => !_excludedTeamIds.contains(team.id));
      _teamsList.addAll(localTeams.map((x) => TeamModel(x)));
    } else {
      _teamsList.addAll(teams.map((x) => TeamModel(x)));
    }
  }

  Future<Team> loadTeam(String id) {
    return _teamsService.getTeam(id);
  }

  void _onTeamUpdated(TeamUpdatedMessage event) {
    initialize();
  }

  void _onTeamDeleted(TeamDeletedMessage event) {
    _teamsList.removeWhere((teamModel) => teamModel.team.id == event.teamId);
    notifyListeners();
  }

  @override
  void dispose() {
    _teamUpdatedSubscription?.cancel();
    _teamDeletedSubscription?.cancel();

    _teamsList.forEach((x) {
      x.dispose();
    });
    super.dispose();
  }
}
