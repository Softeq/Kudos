import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/helpers/image_loading.dart';
import 'package:kudosapp/models/access_level.dart';
import 'package:kudosapp/models/messages/team_updated_message.dart';
import 'package:kudosapp/models/team_member_model.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_access_level.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/analytics_service.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/data_services/teams_service.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/services/image_service.dart';
import 'package:kudosapp/services/navigation_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class EditTeamViewModel extends BaseViewModel with ImageLoading {
  final _eventBus = locator<EventBus>();
  final _teamsService = locator<TeamsService>();
  final _imageService = locator<ImageService>();
  final _authService = locator<BaseAuthService>();
  final _dialogService = locator<DialogService>();
  final _analyticsService = locator<AnalyticsService>();
  final _navigationService = locator<NavigationService>();

  final TeamModel _initialTeam;
  final TeamModel _team = TeamModel.empty();

  EditTeamViewModel([this._initialTeam]) {
    if (_initialTeam != null) {
      _team.updateWithModel(_initialTeam);
    } else {
      _team.accessLevel = AccessLevel.public;
      _team.members = {
        _authService.currentUser.id: TeamMemberModel.fromUserModel(
            _authService.currentUser, UserAccessLevel.admin)
      };
    }
  }

  String get pageTitle =>
      isNewTeam ? localizer().createTeam : localizer().editTeam;

  String get name => _team.name ?? "";

  String get description => _team.description ?? "";

  File get imageFile => _team.imageFile;

  String get imageUrl => _team.imageUrl;

  AccessLevel get accessLevel => _team.accessLevel;

  bool get isNewTeam => _team.id == null;

  set accessLevel(AccessLevel value) {
    _team.accessLevel = value;
    notifyListeners();
  }

  void pickFile(BuildContext context) async {
    if (isImageLoading) {
      return;
    }

    isImageLoading = true;
    _team.imageFile = await _imageService.pickImage(context) ?? _team.imageFile;
    isImageLoading = false;
  }

  Future<void> save(
    BuildContext context,
    String name,
    String description,
  ) async {
    TeamModel updatedTeam;

    _team.name = name;
    _team.description = description;

    try {
      isBusy = true;

      var isTeamNameUnique =
          await _teamsService.isTeamNameUnique(name.trim(), _team.id);
      if (!isTeamNameUnique) {
        _dialogService.showOkDialog(
            context: context,
            title: localizer().error,
            content: localizer().teamNameExists);
        return;
      }

      if (isNewTeam) {
        updatedTeam = await _teamsService.createTeam(_team);
        _analyticsService.logTeamCreated();
      } else {
        updatedTeam = await _teamsService.editTeam(_team);
        _analyticsService.logTeamUpdated();
      }
    } finally {
      isBusy = false;
    }

    if (updatedTeam != null) {
      _initialTeam?.updateWithModel(updatedTeam);
      _eventBus.fire(TeamUpdatedMessage(updatedTeam));
    }

    _navigationService.pop(context);
  }
}
