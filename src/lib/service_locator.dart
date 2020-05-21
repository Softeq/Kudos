import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/services/auth_service.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/services/teams_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator
    ..registerLazySingleton<BaseAuthService>(() => AuthService())
    ..registerFactory(() => PeopleService())
    ..registerFactory(() => AchievementsService())
    ..registerLazySingleton<TeamsService>(() => TeamsService())
    ..registerLazySingleton<EventBus>(() => EventBus());
}
