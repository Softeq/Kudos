import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:kudosapp/l10n/localizer.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/services/auth_service.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/services/teams_service.dart';

GetIt locator = GetIt.instance;

Localizer localizer([BuildContext context]) {
  return Localizer.of(context ?? Get.context);
}

void setupLocator() {
  locator
    ..registerLazySingleton<BaseAuthService>(() => AuthService())
    ..registerFactory(() => PeopleService())
    ..registerFactory(() => AchievementsService())
    ..registerLazySingleton<TeamsService>(() => TeamsService())
    ..registerLazySingleton<EventBus>(() => EventBus());
}
