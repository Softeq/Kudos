import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/models/messages/team_updated_message.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/database/teams_service.dart';
import 'package:kudosapp/services/image_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class EditTeamViewModel extends BaseViewModel {
  final _eventBus = locator<EventBus>();
  final _teamsService = locator<TeamsService>();
  final _imageService = locator<ImageService>();

  final TeamModel _initialTeam;
  final TeamModel _team = new TeamModel();

  bool _isImageLoading;

  EditTeamViewModel(this._initialTeam) {
    _isImageLoading = false;
    _team.updateWithModel(_initialTeam);
  }

  bool get isImageLoading => _isImageLoading;
  set isImageLoading(bool value) {
    if (_isImageLoading != value) {
      _isImageLoading = value;
      notifyListeners();
    }
  }

  String get pageTitle =>
      _team.id == null ? localizer().createTeam : localizer().editTeam;

  String get name => _team.name ?? "";
  String get description => _team.description ?? "";

  File get imageFile => _team.imageFile;
  String get imageUrl => _team.imageUrl;

  void pickFile(BuildContext context) async {
    if (_isImageLoading) {
      return;
    }

    isImageLoading = true;
    _team.imageFile = await _imageService.pickImage(context) ?? _team.imageFile;
    isImageLoading = false;
  }

  Future<void> save(String name, String description) async {
    TeamModel updatedTeam;

    try {
      isBusy = true;

      if (_team.id == null) {
        updatedTeam = await _teamsService.createTeam(_team);
      } else {
        updatedTeam = await _teamsService.editTeam(_team);
      }
    } finally {
      isBusy = false;
    }

    if (updatedTeam != null) {
      _initialTeam?.updateWithModel(updatedTeam);
      _eventBus.fire(TeamUpdatedMessage(updatedTeam));
    }
  }
}
