import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/teams_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class MyTeamsViewModel extends BaseViewModel {
  final items = List<Team>();

  final _teamsService = locator<TeamsService>();

  MyTeamsViewModel() {
    isBusy = true;
  }

  Future<void> initialize() async {
    isBusy = true;

    var teams = await _teamsService.getTeams();

    items.clear();
    items.addAll(teams);

    isBusy = false;
  }

  Future<Team> loadTeam(String id) {
    return _teamsService.getTeam(id);
  }
}
