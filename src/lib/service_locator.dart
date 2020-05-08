import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/services/mock_auth_service.dart';
import 'package:kudosapp/services/people_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() async {
  locator.registerFactory(() => PeopleService());
  locator.registerFactory(() => AchievementsService());
  locator.registerLazySingleton(() => LocalizationService());

  // locator.registerLazySingleton<BaseAuthService>(() => AuthService());
  locator.registerLazySingleton<BaseAuthService>(() => MockAuthService());

  locator.registerLazySingletonAsync<FirebaseApp>(() async {
    var app = await FirebaseApp.configure(
      name: "Kudos Android",
      options: const FirebaseOptions(
        googleAppID: "1:236308904782:android:4529043857065b63c7fc1f",
        gcmSenderID: "236308904782",
        apiKey: "AIzaSyBZqnDHziEM5hjdZwFGWzxxbYHXitv7ess",
        projectID: "softeq-kudos",
      ),
    );
    return app;
  });

  locator.registerLazySingletonAsync<Firestore>(() async {
    var app = await locator.getAsync<FirebaseApp>();
    return Firestore(app: app);
  });

  locator.registerLazySingletonAsync<FirebaseStorage>(() async {
    var app = await locator.getAsync<FirebaseApp>();
    return FirebaseStorage(
      app: app,
      storageBucket: "gs://softeq-kudos.appspot.com",
    );
  });
}
