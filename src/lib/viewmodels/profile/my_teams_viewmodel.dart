import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/models/messages/team_updated_message.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/database/teams_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';

class MyTeamsViewModel extends BaseViewModel {
  final items = List<TeamViewModel>();

  final _teamsService = locator<TeamsService>();
  final _eventBus = locator<EventBus>();

  StreamSubscription _streamSubscription;

  MyTeamsViewModel() {
    isBusy = true;
  }

  Future<void> initialize() async {
    isBusy = true;

    var teams = await _teamsService.getTeams();

    items.forEach((x) {
      x.dispose();
    });
    items.clear();
    items.addAll(teams.map((x) => TeamViewModel(x)));

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
    items.forEach((x) {
      x.dispose();
    });
    super.dispose();
  }
}

class TeamViewModel {
  final Team team;
  final ImageViewModel imageViewModel;

  TeamViewModel(this.team)
      : imageViewModel = ImageViewModel()
          ..initialize(
            team.imageUrl,
            null,
            false,
          );

  void dispose() {
    imageViewModel.dispose();
  }
}
