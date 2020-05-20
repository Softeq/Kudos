import 'package:event_bus/event_bus.dart';
import 'package:kudosapp/models/messages/team_updated_message.dart';
import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/teams_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class EditTeamViewModel extends BaseViewModel {
  final _teamsService = locator<TeamsService>();
  final _eventBus = locator<EventBus>();
  final Team initialTeam;

  factory EditTeamViewModel.fromTeam(Team team) {
    return EditTeamViewModel._(team);
  }

  EditTeamViewModel._(
    this.initialTeam,
  );

  bool get isCreating => initialTeam == null;

  String get initialName {
    return isCreating ? "" : initialTeam.name;
  }

  String get initialDescription {
    return isCreating ? "" : initialTeam.description;
  }

  Future<Team> save(String name, String description) async {
    isBusy = true;
    Team team;
    try {
      if (isCreating) {
        team = await _teamsService.createTeam(name, description);
      } else {
        await _teamsService.editTeam(initialTeam.id, name, description);
        team = initialTeam.copy(
          name: name,
          description: description,
        );
      }
    } finally {
      isBusy = false;
    }

    if (team != null) {
      _eventBus.fire(TeamUpdatedMessage(team));
    }

    return team;
  }
}
