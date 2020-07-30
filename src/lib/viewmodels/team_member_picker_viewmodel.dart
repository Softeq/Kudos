import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kudosapp/helpers/queue_handler.dart';
import 'package:kudosapp/models/team_member_model.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_access_level.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/services/teams_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

enum UserState {
  None,
  Member,
  Admin,
}

class TeamMemberPickerViewModel extends BaseViewModel {
  final _peopleService = locator<PeopleService>();
  final _dialogService = locator<DialogService>();
  final _teamsService = locator<TeamsService>();

  final Map<String, TeamMemberModel> _teamMembers;
  final TeamModel _team;
  final users = List<UserModel>();

  bool _searchPerformed;
  QueueHandler<List<UserModel>, String> _searchQueueHandler;
  StreamSubscription<List<UserModel>> _searchStreamSubscription;

  TeamMemberPickerViewModel(this._team)
      : _teamMembers = Map.from(_team.members) {
    _initialize();
  }

  void _initialize() async {
    _searchPerformed = false;
    _searchQueueHandler = QueueHandler<List<UserModel>, String>(_findPeople);
    _searchStreamSubscription =
        _searchQueueHandler.responseStream.listen(_updateSearchResults);
    requestSearch("");
  }

  void requestSearch(String x) {
    _searchPerformed = true;
    _searchQueueHandler.addRequest(x);
  }

  void onUserClicked(UserModel user) {
    if (!_teamMembers.containsKey(user.id)) {
      _teamMembers[user.id] = TeamMemberModel.fromUserModel(
        user,
        UserAccessLevel.member,
      );
    } else if (_teamMembers[user.id].accessLevel == UserAccessLevel.member) {
      _teamMembers[user.id].accessLevel = UserAccessLevel.admin;
    } else {
      _teamMembers.remove(user.id);
    }
    notifyListeners();
  }

  UserState getUserState(UserModel user) {
    if (!_teamMembers.containsKey(user.id)) {
      return UserState.None;
    } else if (_teamMembers[user.id].accessLevel == UserAccessLevel.member) {
      return UserState.Member;
    } else {
      return UserState.Admin;
    }
  }

  void saveChanges(BuildContext context) async {
    var adminSelected = _teamMembers.values
        .any((tm) => tm.accessLevel == UserAccessLevel.admin);
    if (!adminSelected) {
      _dialogService.showOkDialog(
        context: context,
        title: localizer().error,
        content: localizer().teamMemberPickerEmptyMessage,
      );
      return;
    }

    try {
      isBusy = true;

      await _teamsService.updateTeamMembers(
        _team,
        _teamMembers.values.toList(),
      );

      _team.members.clear();
      _team.members.addEntries(_teamMembers.entries);

      Navigator.of(context).pop();
    } finally {
      isBusy = false;
    }
  }

  Future<List<UserModel>> _findPeople(String request) async {
    var result = await _peopleService.find(request, true);
    if (_teamMembers.isNotEmpty) {
      result.sort((x, y) {
        var xSelected = _teamMembers.containsKey(x.id);
        var ySelected = _teamMembers.containsKey(y.id);
        return xSelected == ySelected
            ? x.name.compareTo(y.name)
            : (xSelected ? -1 : 1);
      });
    }

    return result;
  }

  void _updateSearchResults(List<UserModel> results) {
    if (!_searchPerformed) {
      return;
    }
    _searchPerformed = false;

    users.clear();
    users.addAll(results);

    notifyListeners();
  }

  @override
  void dispose() {
    _searchQueueHandler.close();
    _searchStreamSubscription.cancel();
    super.dispose();
  }
}
