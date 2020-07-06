import 'package:flutter/material.dart';
import 'package:kudosapp/models/team_model.dart';

@immutable
class TeamUpdatedMessage {
  final TeamModel team;

  TeamUpdatedMessage(this.team);
}
