import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/list_notifier.dart';
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

  StreamSubscription _streamSubscription;

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

    _streamSubscription?.cancel();
    _streamSubscription =
        _eventBus.on<AchievementUpdatedMessage>().listen(_onAchievementUpdated);

    isBusy = false;
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
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
}
