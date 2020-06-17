import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/models/messages/achievement_deleted_message.dart';
import 'package:kudosapp/models/messages/achievement_transferred_message.dart';
import 'package:kudosapp/models/messages/achievement_updated_message.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/database/achievements_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class MyAchievementsViewModel extends BaseViewModel {
  final _achievementsService = locator<AchievementsService>();
  final _viewModelList = ListNotifier<AchievementModel>();
  final _authService = locator<BaseAuthService>();
  final _eventBus = locator<EventBus>();

  StreamSubscription _achievementUpdatedSubscription;
  StreamSubscription _achievementDeletedSubscription;
  StreamSubscription _achievementTransferredSubscription;

  MyAchievementsViewModel() {
    isBusy = true;
  }

  ListNotifier<AchievementModel> get items => _viewModelList;

  User get currentUser => _authService.currentUser;

  Future<void> initialize() async {
    isBusy = true;

    var achievements = await _achievementsService.getMyAchievements();
    var viewModels = achievements.map((x) => AchievementModel(x));

    _viewModelList.items.forEach((x) => x.dispose());
    _viewModelList.replace(viewModels);

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

    isBusy = false;
  }

  @override
  void dispose() {
    _achievementUpdatedSubscription?.cancel();
    _achievementDeletedSubscription?.cancel();
    _achievementTransferredSubscription?.cancel();

    super.dispose();
  }

  void _onAchievementUpdated(AchievementUpdatedMessage event) {
    var userId = currentUser.id;
    if (event.achievement.userReference?.id != userId) {
      return;
    }

    var achievementModel = _viewModelList.items.firstWhere(
      (x) => x.achievement.id == event.achievement.id,
      orElse: () => null,
    );
    if (achievementModel != null) {
      achievementModel.initialize(event.achievement);
      _viewModelList.notifyListeners();
    } else {
      _viewModelList.add(AchievementModel(event.achievement));
    }
  }

  void _onAchievementDeleted(AchievementDeletedMessage event) {
    _viewModelList.items
        .removeWhere((element) => event.ids.contains(element.achievement.id));
    _viewModelList.notifyListeners();
  }

  void _onAchievementTransferred(AchievementTransferredMessage event) {
    if (event.achievements.first.userReference?.id !=
        _authService.currentUser.id) {
      var achievementIds = event.achievements.map((a) => a.id).toSet();
      _viewModelList.items.removeWhere(
          (element) => achievementIds.contains(element.achievement.id));
    } else {
      for (var achievement in event.achievements) {
        var achievementIds =
            _viewModelList.items.map((a) => a.achievement.id).toSet();
        if (!achievementIds.contains(achievement.id)) {
          _viewModelList.items.add(AchievementModel(achievement));
        }
      }
    }

    _viewModelList.notifyListeners();
  }
}
