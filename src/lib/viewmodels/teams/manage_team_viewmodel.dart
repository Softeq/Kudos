import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/models/team_member.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/teams_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class ManageTeamViewModel extends BaseViewModel {
  final members = ListNotifier<TeamMemberViewModel>();

  final _random = Random();
  final _teamsService = locator<TeamsService>();
  Team _initialTeam;

  String get name => _initialTeam.name;

  String get description => _initialTeam.description;

  List<TeamMember> get owners => _initialTeam.owners;

  bool get isInitialized => _initialTeam != null;

  Team get team {
    return _initialTeam.copy(
        members: members.items.map((x) => x.teamMember).toList());
  }

  void initialize(Team team) {
    _initialTeam = team;
    members.replace(team.members.map(_createTeamMemberViewModel));
    notifyListeners();
  }

  @override
  void dispose() {
    members.dispose();
    super.dispose();
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

class ListNotifier<T> extends ChangeNotifier {
  final List<T> items = List<T>();

  void replace(Iterable<T> newItems) {
    items.clear();
    items.addAll(newItems);
    notifyListeners();
  }
}
