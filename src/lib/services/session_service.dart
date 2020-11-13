import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/data_services/achievements_service.dart';
import 'package:kudosapp/services/data_services/teams_service.dart';
import 'package:kudosapp/services/data_services/users_service.dart';
import 'package:kudosapp/services/database/mandatory_update_database_service.dart';
import 'package:kudosapp/services/push_notifications_service.dart';

class SessionService {
  final _usersService = locator<UsersService>();
  final _teamsService = locator<TeamsService>();
  final _authService = locator<BaseAuthService>();
  final _achievementsService = locator<AchievementsService>();
  final _pushNotificationsService = locator<PushNotificationsService>();
  final _mandatoryUpdateDatabaseService =
      locator<MandatoryUpdateDatabaseService>();

  Future<void> startSession() async {
    await _authService.signIn();
    final pushToken =
        await _pushNotificationsService.subscribeForNotifications();
    await _usersService.tryRegisterCurrentUser(pushToken);
  }

  Future<void> closeSession() async {
    await _pushNotificationsService.unsubscribeFromNotifications();
    _usersService.closeSubscriptions();
    _teamsService.closeSubscriptions();
    _achievementsService.closeSubscriptions();
    _mandatoryUpdateDatabaseService.closeSubscriptions();
    await _authService.signOut();
  }
}
