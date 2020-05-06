import 'package:get_it/get_it.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/services/localization_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() => AchievementsService());
  locator.registerLazySingleton(() => LocalizationService());
}
