import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/models/access_level.dart';
import 'package:kudosapp/models/team_member_model.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/cache/cached_data_service.dart';
import 'package:kudosapp/services/cache/item_change.dart';
import 'package:kudosapp/services/database/teams_database_service.dart';
import 'package:kudosapp/services/image_service.dart';

class TeamsService extends CachedDataService<Team, TeamModel> {
  static const InputStreamsCount = 2;

  final _imageService = locator<ImageService>();
  final _authService = locator<BaseAuthService>();
  final _teamsDatabaseService = locator<TeamsDatabaseService>();

  TeamsService() : super(InputStreamsCount);

  Future<List<TeamModel>> getTeams() async {
    await loadData();
    return cachedData.values.toList();
  }

  Future<Map<String, TeamModel>> getTeamsMap() async {
    await loadData();
    return cachedData;
  }

  Future<List<TeamModel>> getUserTeams(String userId) async {
    final privateUserTeams = await _teamsDatabaseService.getUserTeams(userId);

    final privateUserTeamModels =
        privateUserTeams.map((t) => TeamModel.fromTeam(t)).toList();

    final cachedTeams = await getTeams();

    final result = cachedTeams
        .where((x) =>
            x.members.containsKey(userId) &&
            x.accessLevel != AccessLevel.private)
        .toList();

    result.addAll(privateUserTeamModels);

    return result;
  }

  Future<TeamModel> getTeam(String teamId) async {
    await loadData();
    if (cachedData.containsKey(teamId)) {
      return cachedData[teamId];
    }

    return _teamsDatabaseService
        .getTeam(teamId)
        .then((t) => TeamModel.fromTeam(t));
  }

  Future<TeamModel> createTeam(TeamModel teamModel) async {
    if (teamModel.imageFile != null) {
      var imageData = await _imageService.uploadImage(teamModel.imageFile);
      teamModel.imageUrl = imageData.url;
      teamModel.imageName = imageData.name;
    }

    var team = Team.fromModel(teamModel);

    return _teamsDatabaseService
        .createTeam(team)
        .then((t) => TeamModel.fromTeam(t));
  }

  Future<TeamModel> editTeam(TeamModel teamModel) async {
    bool updateImage = false;
    if (teamModel.imageFile != null) {
      final imageData = await _imageService.uploadImage(teamModel.imageFile);
      teamModel.imageUrl = imageData.url;
      teamModel.imageName = imageData.name;
      updateImage = true;
    }

    final team = await _teamsDatabaseService.updateTeam(
      Team.fromModel(teamModel),
      updateMetadata: true,
      updateImage: updateImage,
    );

    return TeamModel.fromTeam(team);
  }

  Future<void> updateTeamMembers(
    TeamModel teamModel,
    List<TeamMemberModel> newMembers,
  ) {
    return _teamsDatabaseService.updateTeam(
      Team.fromModel(
        teamModel,
        newMembers: newMembers,
      ),
      updateMembers: true,
    );
  }

  Future<void> deleteTeam(TeamModel teamModel) {
    final team = Team.fromModel(
      teamModel,
      isActive: false,
    );
    return _teamsDatabaseService.updateTeam(
      team,
      updateMetadata: true,
    );
  }

  Future<bool> isTeamNameUnique(String name, String teamId) async {
    var teamIds = await _teamsDatabaseService.findTeamIdsByName(name);
    return teamIds.length == 0 || (teamId != null && teamIds.contains(teamId));
  }

  @override
  TeamModel convert(Team item) => TeamModel.fromTeam(item);

  @override
  Future<Iterable<Team>> getDataFromInputStream(int index) {
    switch (index) {
      // My teams
      case 0:
        return _teamsDatabaseService.getUserTeams(_authService.currentUser.id);
      // Accessible teams (public and protected)
      case 1:
      default:
        return _teamsDatabaseService.getAccessibleTeams();
    }
  }

  @override
  Stream<Iterable<ItemChange<Team>>> getInputStream(int index) {
    switch (index) {
      // My teams
      case 0:
        return _teamsDatabaseService
            .getUserTeamsStream(_authService.currentUser.id);
      // Accessible teams (public and protected)
      case 1:
      default:
        return _teamsDatabaseService.getAccessibleTeamsStream();
    }
  }

  @override
  String getItemId(TeamModel item) => item.id;
}
