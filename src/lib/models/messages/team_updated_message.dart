import 'package:flutter/material.dart';
import 'package:kudosapp/dto/team.dart';

@immutable
class TeamUpdatedMessage {
  final Team team;

  TeamUpdatedMessage(this.team);
}
