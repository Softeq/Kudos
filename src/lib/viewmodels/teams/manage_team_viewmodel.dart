import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/dto/team_member.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/models/messages/achievement_deleted_message.dart';
import 'package:kudosapp/models/messages/achievement_transferred_message.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/models/messages/team_deleted_message.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/database/achievements_service.dart';
import 'package:kudosapp/services/database/teams_service.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';

class ManageTeamViewModel extends BaseViewModel {
  final members = ListNotifier<TeamMember>();
  final admins = ListNotifier<TeamMember>();
  final imageViewModel = ImageViewModel();

  final _achievements = List<AchievementModel>();
  final _achievementsService = locator<AchievementsService>();
  final _teamsService = locator<TeamsService>();
  final _eventBus = locator<EventBus>();
  final _dialogService = locator<DialogService>();

  bool _canEdit;

  Team _initialTeam;

  StreamSubscription _achievementUpdatedSubscription;
  StreamSubscription _achievementDeletedSubscription;
  StreamSubscription _achievementTransferredSubscription;

  String get name => _initialTeam?.name;

  String get description => _initialTeam.description;

  String get imageUrl => _initialTeam.imageUrl;

  String get owners => admins.items.map((x) => x.name).join(", ");

  bool get canEdit {
    if (_canEdit == null) {
      _canEdit = _teamsService.canBeModifiedByCurrentUser(_initialTeam);
    }

    return _canEdit;
  }

  Team get modifiedTeam {
    return _initialTeam.copy(
      members: members.items,
      owners: admins.items,
    );
  }

  int get itemsCount => _achievements.length;

  @override
  void dispose() {
    members.dispose();
    admins.dispose();
    _achievements.forEach((x) {
      x.dispose();
    });
    _achievementUpdatedSubscription?.cancel();
    _achievementDeletedSubscription?.cancel();
    _achievementTransferredSubscription?.cancel();
    imageViewModel.dispose();
    super.dispose();
  }

  Future<void> initialize(String teamId) async {
    isBusy = true;
    final team = await _teamsService.getTeam(teamId);
    _initialTeam = team;
    members.replace(_initialTeam.members);
    admins.replace(_initialTeam.owners);
    _loadAchievements();

    _achievementUpdatedSubscription?.cancel();
    _achievementUpdatedSubscription =
        _eventBus.on<AchievementUpdatedMessage>().listen(_onAchievementUpdated);

    _achievementDeletedSubscription?.cancel();
    _achievementDeletedSubscription =
        _eventBus.on<AchievementDeletedMessage>().listen(_onAchievementDeleted);

    _achievementTransferredSubscription?.cancel();
    _achievementTransferredSubscription = _eventBus
        .on<AchievementTransferredMessage>()
        .listen(_onAchievementTransferred);

    imageViewModel.initialize(team.imageUrl, null, false);
    isBusy = false;
  }

  void updateTeamMetadata(
    String name,
    String description,
    String imageUrl,
    String imageName,
  ) {
    _initialTeam = _initialTeam.copy(
      name: name,
      description: description,
      imageUrl: imageUrl,
      imageName: imageName,
    );
    imageViewModel.initialize(_initialTeam.imageUrl, null, false);
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

  Future<void> deleteTeam(BuildContext context) async {
    if (await _dialogService.showDeleteCancelDialog(
        context: context,
        title: localizer().warning,
        content: localizer().deleteTeamWarning)) {
      isBusy = true;

      await _teamsService.deleteTeam(
          _initialTeam, _achievements.map((e) => e.achievement).toList());

      isBusy = false;
      _eventBus.fire(TeamDeletedMessage(_initialTeam.id));
      _eventBus.fire(AchievementDeletedMessage.multiple(
          _achievements.map((a) => a.achievement.id).toSet()));
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
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

  AchievementModel getData(int index) {
    return _achievements[index];
  }

  void _onAchievementUpdated(AchievementUpdatedMessage event) {
    if (event.achievement.teamReference?.id != _initialTeam.id) {
      return;
    }

    var achievementModel = _achievements.firstWhere(
      (x) => x.achievement.id == event.achievement.id,
      orElse: () => null,
    );
    if (achievementModel != null) {
      achievementModel.initialize(event.achievement);
    } else {
      _achievements.add(AchievementModel(event.achievement));
    }
    notifyListeners();
  }

  void _onAchievementDeleted(AchievementDeletedMessage event) {
    _achievements
        .removeWhere((element) => event.ids.contains(element.achievement.id));
    notifyListeners();
  }

  void _onAchievementTransferred(AchievementTransferredMessage event) {
    if (event.achievements.first.userReference?.id != _initialTeam.id) {
      var achievementIds = event.achievements.map((a) => a.id).toSet();
      _achievements.removeWhere(
          (element) => achievementIds.contains(element.achievement.id));
    } else {
      var achievementIds = _achievements.map((a) => a.achievement.id).toSet();
      for (var achievement in event.achievements) {
        if (!achievementIds.contains(achievement.id)) {
          _achievements.add(AchievementModel(achievement));
        }
      }
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
    _achievements.addAll(result.map((x) => AchievementModel(x)).toList());
    notifyListeners();
  }
}
