import 'dart:async';
import 'dart:math';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
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
  final members = ListNotifier<TeamMemberViewModel>();
  final _achievementsService = locator<AchievementsService>();
  final _achievements = List<AchievementViewModel>();
  final _random = Random();
  final _teamsService = locator<TeamsService>();
  final _eventBus = locator<EventBus>();
  Team _initialTeam;
  StreamSubscription<AchievementUpdatedMessage>
      _onAchievementUpdatedSubscription;

  String get name => _initialTeam.name;

  String get description => _initialTeam.description;

  List<TeamMember> get owners => _initialTeam.owners;

  bool get isInitialized => _initialTeam != null;

  Team get modifiedTeam {
    return _initialTeam.copy(
        members: members.items.map((x) => x.teamMember).toList());
  }

  int get itemsCount => (_achievements.length / 2.0).round() + 1;

  @override
  void dispose() {
    members.dispose();
    _achievements.forEach((x) {
      x.dispose();
    });
    _onAchievementUpdatedSubscription?.cancel();
    super.dispose();
  }

  void initialize(Team team) {
    _initialTeam = team;
    members.replace(team.members.map(_createTeamMemberViewModel));
    notifyListeners();
    _refreshAchievement();

    _onAchievementUpdatedSubscription?.cancel();
    _onAchievementUpdatedSubscription =
        _eventBus.on<AchievementUpdatedMessage>().listen(_onAchievementUpdated);
  }

  void replaceMembers(Iterable<User> users) {
    if (users == null) {
      return;
    }

    var teamMembers = users.map(
      (x) {
        return _createTeamMemberViewModel(TeamMember.fromUser(x));
      },
    );
    members.replace(teamMembers);
    _saveMembers();
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

  Future<void> _refreshAchievement() async {
    var result =
        await _achievementsService.getTeamAchievements(_initialTeam.id);
    _achievements.forEach((x) {
      x.dispose();
    });
    _achievements.clear();
    _achievements.addAll(result.map((x) => AchievementViewModel(x)));
    notifyListeners();
  }

  Future<void> _saveMembers() {
    return _teamsService.updateTeamMembers(
      _initialTeam.id,
      members.items.map((x) => x.teamMember).toList(),
    );
  }

  TeamMemberViewModel _createTeamMemberViewModel(TeamMember teamMember) {
    var color = Color.fromARGB(
      255,
      _random.nextInt(255),
      _random.nextInt(255),
      _random.nextInt(255),
    );
    return TeamMemberViewModel(
      teamMember: teamMember,
      color: color,
    );
  }
}

class TeamMemberViewModel {
  final TeamMember teamMember;
  final Color color;

  TeamMemberViewModel({
    this.teamMember,
    this.color,
  });
}
