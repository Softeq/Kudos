import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/navigation_service.dart';
import 'package:kudosapp/viewmodels/mandatory_update_viewmodel.dart';

class MandatoryUpdateDatabaseService {
  final _database = FirebaseFirestore.instance;
  final _navigationService = locator<NavigationService>();
  final _databaseVersion = 1;

  StreamSubscription _appUpdateSubscription;

  void refreshSubscriptions() {
    closeSubscriptions();

    _appUpdateSubscription = _database
        .collection("config")
        .doc("database_version")
        .snapshots()
        .listen(
          (ds) {
        final data = ds.data();
        final int version = data["version"];
        if (_databaseVersion < version) {
          _navigationService.replace(MandatoryUpdateViewModel());
        }
      },
    );
  }

  void closeSubscriptions() {
    _appUpdateSubscription?.cancel();
    _appUpdateSubscription = null;
  }
}
