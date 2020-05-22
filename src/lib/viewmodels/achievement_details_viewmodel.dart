import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:kudosapp/models/achievement_holder.dart';
import 'package:kudosapp/models/achievement_to_send.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/viewmodels/achievement_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

enum OwnerType { user, team }

class AchievementDetailsViewModel extends BaseViewModel {
  final _achievementsService = locator<AchievementsService>();
  final _peopleService = locator<PeopleService>();
  final _eventBus = locator<EventBus>();
  final _authService = locator<BaseAuthService>();
  final String _achievementId;

  StreamSubscription<AchievementUpdatedMessage> _subscription;
  List<AchievementHolder> _achievementHolders;
  AchievementViewModel _achievementViewModel;
  double _statisticsValue = 0;
  String _ownerName = "";
  String _ownerId = "";
  OwnerType _ownerType;

  AchievementDetailsViewModel(this._achievementId) {
    isBusy = true;
  }

  AchievementViewModel get achievementViewModel => _achievementViewModel;
  List<AchievementHolder> get achievementHolders => _achievementHolders;
  double get statisticsValue => _statisticsValue;

  String get ownerName => _ownerName;
  String get ownerId => _ownerId;
  OwnerType get ownerType => _ownerType;

  Future<void> initialize() async {
    final achievement =
        await _achievementsService.getAchievement(_achievementId);

    _achievementViewModel = AchievementViewModel(achievement);
    _subscription?.cancel();
    _subscription =
        _eventBus.on<AchievementUpdatedMessage>().listen(_onAchievementUpdated);

    // TODO YP: move to separate widgets
    await loadStatistics();
    await loadOwnerInfo();

    isBusy = false;
  }

  Future<void> loadOwnerInfo() async {
    if (_achievementViewModel.teamId != null) {
      _ownerName = _achievementViewModel.teamName;
      _ownerType = OwnerType.team;
      _ownerId = _achievementViewModel.teamId;
    } else {
      final userIds = [_achievementViewModel.userId];
      var owners = await _peopleService.getUsersByIds(userIds);
      _ownerName = owners.first.name;
      _ownerType = OwnerType.user;
      _ownerId = _achievementViewModel.userId;
    }
  }

  Future<void> loadStatistics() async {
    // Number of users with this badge divided by the total number of users
    _achievementHolders = await _achievementsService
        .getAchievementHolders(achievementViewModel.achievement.id);

    //TODO VPY: find better solution to get people count
    var allUsers = await _peopleService.getAllUsers();
    _statisticsValue =
        allUsers.length == 0 ? 0 : _achievementHolders.length / allUsers.length;
  }

  Future<void> sendTo(User recipient, String comment) async {
    final achievementToSend = AchievementToSend(
      sender: _authService.currentUser,
      recipient: recipient,
      achievement: achievementViewModel.achievement,
      comment: comment,
    );

    await _achievementsService.sendAchievement(achievementToSend);
  }

  @override
  void dispose() {
    _achievementViewModel.dispose();
    _subscription.cancel();
    super.dispose();
  }

  void _onAchievementUpdated(AchievementUpdatedMessage event) {
    if (event.achievement.id != _achievementViewModel.achievement.id) {
      return;
    }

    _achievementViewModel.initialize(event.achievement);
    notifyListeners();
  }
}
