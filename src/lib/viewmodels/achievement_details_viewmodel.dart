import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:kudosapp/models/achievement_holder.dart';
import 'package:kudosapp/models/achievement_to_send.dart';
import 'package:kudosapp/models/list_notifier.dart';
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
  AchievementViewModel _achievementViewModel;
  double _statisticsValue = 0;
  String _ownerName = "";
  String _ownerId = "";
  OwnerType _ownerType;

  final ListNotifier<AchievementHolder> achievementHolders = new ListNotifier();

  AchievementViewModel get achievementViewModel => _achievementViewModel;
  double get statisticsValue => _statisticsValue;

  String get ownerName => _ownerName;
  String get ownerId => _ownerId;
  OwnerType get ownerType => _ownerType;

  AchievementDetailsViewModel(this._achievementId) {
    isBusy = true;
  }

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
    achievementHolders.replace(await _achievementsService
        .getAchievementHolders(achievementViewModel.achievement.id));

    var allUsersCount = await _peopleService.getUsersCount();
    _statisticsValue = allUsersCount == 0
        ? 0
        : achievementHolders.items.length / allUsersCount;
  }

  Future<void> sendTo(User recipient, String comment) async {
    isBusy = true;
    final achievementToSend = AchievementToSend(
      sender: _authService.currentUser,
      recipient: recipient,
      achievement: achievementViewModel.achievement,
      comment: comment,
    );

    await _achievementsService.sendAchievement(achievementToSend);
    await initialize();
    isBusy = false;
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
