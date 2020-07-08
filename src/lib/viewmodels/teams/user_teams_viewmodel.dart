import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/teams_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class UserTeamsViewModel extends BaseViewModel {
  final _teamsService = locator<TeamsService>();

  final String _userId;
  final teamNames = List<String>();

  UserTeamsViewModel(this._userId) {
    _initialize();
  }

  void _initialize() async {
    var teams = await _teamsService.getTeams(_userId);
    teamNames.addAll(teams.map((x) => x.name));
    notifyListeners();
  }
}
