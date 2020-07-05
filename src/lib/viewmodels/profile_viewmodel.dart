import 'package:kudosapp/helpers/disposable.dart';
import 'package:kudosapp/helpers/list_notifier.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/database/people_service.dart';
import 'package:kudosapp/services/database/teams_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class ProfileViewModel extends BaseViewModel with Disposable {
  final TeamsService _teamsService = locator<TeamsService>();
  final PeopleService _peopleService = locator<PeopleService>();

  final UserModel user;
  final ListNotifier<TeamModel> userTeams = new ListNotifier<TeamModel>();

  String get imageUrl => user.imageUrl;
  String get userName => user.name ?? "";

  ProfileViewModel(this.user) {
    _initialize();
  }

  void _initialize() async {
    final loadedUser = await _peopleService.getUserById(user.id);
    user.updateWithModel(loadedUser);

    final teams = await _teamsService.getTeams(user.id);
    userTeams.replace(teams);

    notifyListeners();
  }
}
