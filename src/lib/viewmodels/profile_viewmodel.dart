import 'package:kudosapp/helpers/disposable.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/services/teams_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class ProfileViewModel extends BaseViewModel with Disposable {
  final PeopleService _peopleService = locator<PeopleService>();
  final TeamsService _teamsService = locator<TeamsService>();
  final String _userId;

  User _user;

  ProfileViewModel(this._userId);

  User get user => _user;

  final ListNotifier<Team> userTeams = new ListNotifier<Team>();

  Future<void> initialize() async {
    final user = await _peopleService.getUserById(_userId);
    _user = user;

    final teams = await _teamsService.getTeams(_userId);
    userTeams.replace(teams);

    if (!isDisposed) {
      notifyListeners();
    }
  }
}
