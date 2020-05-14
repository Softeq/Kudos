import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/teams_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class EditTeamViewModel extends BaseViewModel {
  final TeamsService _teamsService = locator<TeamsService>();
  final Team initialTeam;

  factory EditTeamViewModel.fromTeam(Team team) {
    return EditTeamViewModel._(team);
  }

  EditTeamViewModel._(this.initialTeam,);

  bool get isCreating => initialTeam == null;

  String get initialName {
    return isCreating ? "" : initialTeam.name;
  }

  String get initialDescription {
    return isCreating ? "" : initialTeam.description;
  }

  Future<void> save(String name, String description) async {
    isBusy = true;
    try {
      if (isCreating) {
        await _teamsService.createTeam(name, description);
      } else {
        await _teamsService.editTeam(initialTeam.id, name, description);
      }
    } finally {
      isBusy = false;
    }
  }
}
