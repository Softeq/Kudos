import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/models/team_member.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/services/teams_service.dart';
import 'package:kudosapp/viewmodels/achievement_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class ManageTeamViewModel extends BaseViewModel {
  final members = ListNotifier<TeamMember>();
  final admins = ListNotifier<TeamMember>();

  final _achievements = List<AchievementViewModel>();
  final _achievementsService = locator<AchievementsService>();
  final _teamsService = locator<TeamsService>();
  final _eventBus = locator<EventBus>();

  Team _initialTeam;
  StreamSubscription<AchievementUpdatedMessage>
  _onAchievementUpdatedSubscription;

  String get name => _initialTeam.name;

  String get description => _initialTeam.description;

  String get owners => admins.items.map((x) => x.name).join(", ");

  Team get modifiedTeam {
    return _initialTeam.copy(
      members: members.items,
      owners: admins.items,
    );
  }

  int get itemsCount => (_achievements.length / 2.0).round() + 1;

  @override
  void dispose() {
    members.dispose();
    admins.dispose();
    _achievements.forEach((x) {
      x.dispose();
    });
    _onAchievementUpdatedSubscription?.cancel();
    super.dispose();
  }

  Future<void> initialize(String teamId) async {
    isBusy = true;
    final team = await _teamsService.getTeam(teamId);
    _initialTeam = team;
    members.replace(_initialTeam.members);
    admins.replace(_initialTeam.owners);
    _loadAchievements();
    _onAchievementUpdatedSubscription?.cancel();
    _onAchievementUpdatedSubscription =
        _eventBus.on<AchievementUpdatedMessage>().listen(_onAchievementUpdated);
    isBusy = false;
  }

  void updateTeamMetadata(String name, String description) {
    _initialTeam = _initialTeam.copy(
      name: name,
      description: description,
    );
    notifyListeners();
  }

  void replaceMembers(Iterable<User> users) {
    if (users == null) {
      return;
    }

    var teamMembers = users.map((x) => TeamMember.fromUser(x)).toList();
    members.replace(teamMembers);

    _teamsService.updateTeamMembers(
      teamId: _initialTeam.id,
      newMembers: teamMembers,
      newAdmins: admins.items,
    );
  }

  void replaceAdmins(Iterable<User> users) {
    if (users == null || users.isEmpty) {
      return;
    }

    var owners = users.map((x) => TeamMember.fromUser(x)).toList();
    admins.replace(owners);

    _teamsService.updateTeamMembers(
      teamId: _initialTeam.id,
      newMembers: members.items,
      newAdmins: owners,
    );
  }

  List<AchievementViewModel> getData(int index) {
    var index2 = index * 2 - 1;
    var index1 = index2 - 1;

    var list = List<AchievementViewModel>();
    list.add(_achievements[index1]);
    if (index2 < _achievements.length) {
      list.add(_achievements[index2]);
    }
    return list;
  }

  void _onAchievementUpdated(AchievementUpdatedMessage event) {
    if (event.achievement.teamReference?.id != _initialTeam.id) {
      return;
    }

    var achievementViewModel = _achievements.firstWhere(
          (x) => x.achievement.id == event.achievement.id,
      orElse: () => null,
    );
    if (achievementViewModel != null) {
      achievementViewModel.initialize(event.achievement);
    } else {
      _achievements.add(AchievementViewModel(event.achievement));
    }
    notifyListeners();
  }

  Future<void> _loadAchievements() async {
    var result =
    await _achievementsService.getTeamAchievements(_initialTeam.id);
    _achievements.toList().forEach((x) {
      x.dispose();
    });
    _achievements.clear();
    _achievements.addAll(result.map((x) => AchievementViewModel(x)).toList());
    notifyListeners();
  }
}
