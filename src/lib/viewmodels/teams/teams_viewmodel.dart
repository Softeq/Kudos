import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/teams_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class TeamsViewModel extends BaseViewModel {
  final _teamsService = locator<TeamsService>();

  List<Team> teams = List<Team>();

  Future<void> refresh() async {
    var result = await _teamsService.getTeams();
    teams.clear();
    teams.addAll(result);
    notifyListeners();
  }

  Future<Team> loadTeam(String id) {
    return _teamsService.getTeam(id);
  }
}
