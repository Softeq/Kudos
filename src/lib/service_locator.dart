import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:kudosapp/generated/l10n.dart';
import 'package:kudosapp/services/analytics_service.dart';
import 'package:kudosapp/services/auth_service.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/data_services/achievements_service.dart';
import 'package:kudosapp/services/data_services/teams_service.dart';
import 'package:kudosapp/services/data_services/users_service.dart';
import 'package:kudosapp/services/database/achievements_database_service.dart';
import 'package:kudosapp/services/database/database_service.dart';
import 'package:kudosapp/services/database/mandatory_update_database_service.dart';
import 'package:kudosapp/services/database/teams_database_service.dart';
import 'package:kudosapp/services/database/users_database_service.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/services/file_service.dart';
import 'package:kudosapp/services/image_service.dart';
import 'package:kudosapp/services/navigation_service.dart';
import 'package:kudosapp/services/page_mapper_service.dart';
import 'package:kudosapp/services/push_notifications_service.dart';
import 'package:kudosapp/services/session_service.dart';
import 'package:kudosapp/services/snack_bar_notifier_service.dart';

GetIt locator = GetIt.instance;

S localizer([BuildContext context]) => S.of(context ?? Get.context);

void setupLocator() {
  locator
    ..registerLazySingleton<BaseAuthService>(() => AuthService())
    ..registerLazySingleton<UsersService>(() => UsersService())
    ..registerLazySingleton<AchievementsService>(() => AchievementsService())
    ..registerLazySingleton<TeamsService>(() => TeamsService())
    ..registerLazySingleton<EventBus>(() => EventBus())
    ..registerLazySingleton<PushNotificationsService>(
        () => PushNotificationsService())
    ..registerLazySingleton<ImageService>(() => ImageService())
    ..registerLazySingleton<FileService>(() => FileService())
    ..registerLazySingleton<DialogService>(() => DialogService())
    ..registerLazySingleton<SnackBarNotifierService>(
        () => SnackBarNotifierService())
    ..registerLazySingleton<DatabaseService>(() => DatabaseService())
    ..registerLazySingleton<AchievementsDatabaseService>(
        () => AchievementsDatabaseService())
    ..registerLazySingleton<TeamsDatabaseService>(() => TeamsDatabaseService())
    ..registerLazySingleton<UsersDatabaseService>(() => UsersDatabaseService())
    ..registerLazySingleton<SessionService>(() => SessionService())
    ..registerLazySingleton<NavigationService>(() => NavigationService())
    ..registerLazySingleton<PageMapperService>(() => PageMapperService())
    ..registerLazySingleton<AnalyticsService>(() => AnalyticsService())
    ..registerLazySingleton<MandatoryUpdateDatabaseService>(
        () => MandatoryUpdateDatabaseService());
}
