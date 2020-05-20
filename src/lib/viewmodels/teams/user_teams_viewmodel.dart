import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/teams_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class UserTeamsViewModel extends BaseViewModel {
  final teamNames = List<String>();

  final _teamsService = locator<TeamsService>();

  void initialize(String userId) async {
    var teams = await _teamsService.getTeams(userId);
    teamNames.addAll(teams.map((x) => x.name));
    notifyListeners();
  }
}
