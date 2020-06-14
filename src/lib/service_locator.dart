import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:kudosapp/generated/l10n.dart';
import 'package:kudosapp/services/auth_service.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/database/teams_service.dart';
import 'package:kudosapp/services/dialogs_service.dart';
import 'package:kudosapp/services/file_service.dart';
import 'package:kudosapp/services/database/achievements_service.dart';
import 'package:kudosapp/services/database/people_service.dart';
import 'package:kudosapp/services/image_service.dart';
import 'package:kudosapp/services/push_notifications_service.dart';

GetIt locator = GetIt.instance;

S localizer([BuildContext context]) => S.of(context ?? Get.context);

void setupLocator() {
  locator
    ..registerLazySingleton<BaseAuthService>(() => AuthService())
    ..registerLazySingleton<PeopleService>(() => PeopleService())
    ..registerLazySingleton<AchievementsService>(() => AchievementsService())
    ..registerLazySingleton<TeamsService>(() => TeamsService())
    ..registerLazySingleton<EventBus>(() => EventBus())
    ..registerLazySingleton<PushNotificationsService>(() => PushNotificationsService())
    ..registerLazySingleton<ImageService>(() => ImageService())
    ..registerLazySingleton<FileService>(() => FileService())
    ..registerLazySingleton<DialogsService>(() => DialogsService());
}
